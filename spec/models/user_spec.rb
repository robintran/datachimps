require 'spec_helper'

describe User do
  [:email, :password, :password_confirmation, :remember_me, :provider, :uid, :name, :balanced_account_uri].each do |attr|
    it { should allow_mass_assignment_of attr }
  end

  it { should have_many :contests }
  it { should have_many(:won_contests).class_name('Contest') }

  describe 'after_create' do
    describe '.create_balanced_account' do
      describe 'without existing uri' do
        let(:user) { create(:user, balanced_account_uri: nil) }
        let(:mock_marketplace) { {} }
        let(:uri) { "test_uri" }
        let(:mock_account) { OpenStruct.new(uri: uri) }
        before do
          Balanced::Marketplace.should_receive(:my_marketplace).and_return(mock_marketplace)
          mock_marketplace.should_receive(:create_account).and_return(mock_account)
        end
        it "should create and assign balanced_account_uri" do
          expect(user).to be_persisted
          expect(user.balanced_account_uri).to eq(uri)
        end
      end

      describe 'with existing uri' do
        let(:user) { create(:user) }
        before do
          Balanced::Marketplace.should_not_receive(:my_marketplace)
        end
        it "should create and assign balanced_account_uri" do
          expect(user).to be_persisted
        end
      end
    end
  end

  describe '#find_for_facebook_oauth' do
    let(:provider) { "facebook" }
    let(:uid) { "123456" }
    let(:email) { "test@example.com" }
    let(:name) { "Test" }
    let(:auth_info) do
      OpenStruct.new(
        provider: provider,
        uid: uid,
        info: OpenStruct.new(email: email),
        extra: OpenStruct.new(
          raw_info: OpenStruct.new(name: name)
        )
      )
    end

    let(:result) { User.find_for_facebook_oauth(auth_info) }

    before do
      User.any_instance.stub(:create_balanced_account)
    end

    describe 'with user existed' do
      let!(:user) { create(:user, uid: uid, provider: provider) }
      it "should find and return that user" do
        lambda do
          result.should == user
        end.should_not change(User, :count)
      end
    end

    describe 'without user existed' do
      it "should create new user with info" do
        lambda do
          user = result
          user.email.should == email
          user.uid.should == uid
          user.provider.should == provider
          user.name.should == name
        end.should change(User, :count).by(1)
      end
    end
  end

  describe 'BalancedAccount' do
    let(:user) { create(:user) }

    describe '.marketplace' do
      let(:expected) { "market" }
      before do
        Balanced::Marketplace.should_receive(:my_marketplace).and_return(expected)
      end
      it "should retrieve Balanced market place" do
        expect(user.marketplace).to eq(expected)
      end
    end

    describe '.balanced_account' do
      let(:expected) { "account" }
      before do
        Balanced::Account.should_receive(:find).and_return(expected)
      end
      it "should retrieve Balanced market place" do
        expect(user.balanced_account).to eq(expected)
      end
    end

    describe '.credit_cards' do
      let(:mock_account) { {} }
      let(:expected) { [] }
      before do
        user.should_receive(:balanced_account).and_return(mock_account)
        mock_account.should_receive(:cards).and_return(expected)
      end
      it "should delegate to balanced_account" do
        expect(user.credit_cards).to eq(expected)
      end
    end

    describe '.add_credit_card' do
      let(:mock_marketplace) { OpenStruct.new(cards_uri: "cards_uri") }
      let(:mock_card_info) { {} }
      let(:mock_account) { {} }
      let(:card_uri) { "card_uri" }
      describe 'successful' do
        before do
          user.should_receive(:marketplace).and_return(mock_marketplace)
          Balanced::Card.should_receive(:new).and_return(mock_card_info)
          mock_card_info.should_receive(:save).and_return(OpenStruct.new(uri: card_uri))
          user.should_receive(:balanced_account).and_return(mock_account)
          mock_account.should_receive(:add_card).with(card_uri)
        end
        it "should return true" do
          expect(user.add_credit_card({})).to be_true
        end
      end

      describe 'error' do
        before do
          user.should_receive(:marketplace).and_return(mock_marketplace)
          Balanced::Card.should_receive(:new).and_return(mock_card_info)
          mock_card_info.should_receive(:save).and_raise(Balanced::BadRequest.new(body: {extras: {}}))
        end
        it "should return false" do
          expect(user.add_credit_card({})).to be_false
        end
      end
    end

    describe '.remove_credit_card' do
      let(:mock_card_info) { {} }
      let(:card_uri) { "card_uri" }
      describe 'successful' do
        before do
          Balanced::Card.should_receive(:find).with(card_uri).and_return(mock_card_info)
          mock_card_info.should_receive(:invalidate).and_return(true)
        end
        it "should return true" do
          expect(user.remove_credit_card(card_uri)).to be_true
        end
      end

      describe 'error' do
        before do
          Balanced::Card.should_receive(:find).with(card_uri).and_raise(Balanced::BadRequest.new(body: {extras: {}}))
        end
        it "should return false" do
          expect(user.remove_credit_card(card_uri)).to be_false
        end
      end
    end

    describe '.bank_accounts' do
      let(:mock_account) { {} }
      let(:expected) { [] }
      before do
        user.should_receive(:balanced_account).and_return(mock_account)
        mock_account.should_receive(:bank_accounts).and_return(expected)
      end
      it "should delegate to balanced_account" do
        expect(user.bank_accounts).to eq(expected)
      end
    end

    describe '.add_bank_account' do
      let(:mock_marketplace) { OpenStruct.new(bank_accounts_uri: "bank_accounts_uri") }
      let(:mock_bank_info) { {} }
      let(:mock_account) { {} }
      let(:bank_uri) { "bank_uri" }
      describe 'successful' do
        before do
          user.should_receive(:marketplace).and_return(mock_marketplace)
          Balanced::BankAccount.should_receive(:new).and_return(mock_bank_info)
          mock_bank_info.should_receive(:save).and_return(OpenStruct.new(uri: bank_uri))
          user.should_receive(:balanced_account).and_return(mock_account)
          mock_account.should_receive(:add_bank_account).with(bank_uri)
        end
        it "should return true" do
          expect(user.add_bank_account({})).to be_true
        end
      end

      describe 'error' do
        before do
          user.should_receive(:marketplace).and_return(mock_marketplace)
          Balanced::BankAccount.should_receive(:new).and_return(mock_bank_info)
          mock_bank_info.should_receive(:save).and_raise(Balanced::BadRequest.new(body: {extras: {}}))
        end
        it "should return false" do
          expect(user.add_bank_account({})).to be_false
        end
      end
    end

    describe '.remove_bank_account' do
      let(:mock_bank_info) { {} }
      let(:bank_account_uri) { "bank_account_uri" }
      describe 'successful' do
        before do
          Balanced::BankAccount.should_receive(:find).with(bank_account_uri).and_return(mock_bank_info)
          mock_bank_info.should_receive(:destroy).and_return(true)
        end
        it "should return true" do
          expect(user.remove_bank_account(bank_account_uri)).to be_true
        end
      end

      describe 'error' do
        before do
          Balanced::BankAccount.should_receive(:find).with(bank_account_uri).and_raise(Balanced::BadRequest.new(body: {extras: {}}))
        end
        it "should return false" do
          expect(user.remove_bank_account(bank_account_uri)).to be_false
        end
      end
    end

    describe '.charge' do
      let(:mock_account) { {} }
      let(:extra_options) { {appears_on_statement_as: "abc", description: "desc"} }
      let(:amount) { 1000 }
      let(:options) { extra_options.merge(amount: amount) }
      describe 'successful' do
        before do
          user.should_receive(:balanced_account).and_return(mock_account)
          mock_account.should_receive(:debit).with(options)
        end
        it "shoud return true" do
          expect(user.charge(amount, extra_options)).to be_true
        end
      end

      describe 'error' do
        before do
          user.should_receive(:balanced_account).and_return(mock_account)
          mock_account.should_receive(:debit).with(options).and_raise(Balanced::BadRequest.new(body: {extras: {}}))
        end
        it "shoud return false" do
          expect(user.charge(amount, extra_options)).to be_false
        end
      end
    end

    describe '.credit' do
      let(:mock_account) { {} }
      let(:amount) { 1000 }
      describe 'successful' do
        before do
          user.should_receive(:balanced_account).and_return(mock_account)
          mock_account.should_receive(:credit).with(amount)
        end
        it "shoud return true" do
          expect(user.credit(amount)).to be_true
        end
      end

      describe 'error' do
        before do
          user.should_receive(:balanced_account).and_return(mock_account)
          mock_account.should_receive(:credit).with(amount).and_raise(Balanced::BadRequest.new(body: {extras: {}}))
        end
        it "shoud return false" do
          expect(user.credit(amount)).to be_false
        end
      end
    end
  end

  describe "#follow" do
    it "allow user to follow a contest"
  end
end
