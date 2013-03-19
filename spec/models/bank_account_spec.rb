require 'spec_helper'

describe BankAccount do
  let(:bank_account) { build :bank_account }
  let(:bank_accounts_uri) { 'marketplace_bank_accounts_uri' }
  let(:mocked_balanced_account) { mock(Balanced::Account) }
  let(:mocked_market_place) { stub(bank_accounts_uri: bank_accounts_uri) }
  let(:mocked_bank_account) { mock(Balanced::Card) }

  [:name, :account_number, :routing_number, :type].each do |attr|
    it { should validate_presence_of attr }
  end

  describe '#save' do
    before do
      Balanced::Marketplace.should_receive(:my_marketplace).and_return(mocked_market_place)
      Balanced::BankAccount.should_receive(:new).with(
        bank_uri: bank_accounts_uri,
        type: bank_account.type,
        name: bank_account.name,
        account_number: bank_account.account_number,
        routing_number: bank_account.routing_number
      ).and_return(mocked_bank_account)
    end

    context 'bank_account is valid' do
      before do
        Balanced::Account.should_receive(:find).with(bank_account.user.balanced_account_uri).and_return(mocked_balanced_account)
        mocked_bank_account.should_receive(:save).and_return(mocked_bank_account)
        mocked_bank_account.should_receive(:uri).and_return('mocked_uri')
      end

      it 'should save the bank account' do
        mocked_balanced_account.should_receive(:add_bank_account).with('mocked_uri')
        bank_account.save.should be_true
      end
    end

    context 'bank_account misses information' do
      before do
        mocked_bank_account.should_receive(:save).and_raise(Balanced::BadRequest.new(body: { extras: { 'error' => 'description' } }))
      end

      it 'should return error messages' do
        bank_account.save.should be_false
        bank_account.errors.full_messages.should == ["Error description"]
      end
    end

    context 'bank_account is invalid' do
      before do
        mocked_bank_account.should_receive(:save).and_raise(Balanced::Conflict.new(body: { extras: {}, description: 'description' }))
      end

      it 'should return error messages' do
        bank_account.save.should be_false
        bank_account.errors.full_messages.should == ["description"]
      end

    end
  end
end
