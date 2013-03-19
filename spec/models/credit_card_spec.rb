require 'spec_helper'

describe CreditCard do
  let(:credit_card) { build :credit_card }
  let(:cards_uri) { 'marketplace_cards_uri' }
  let(:mocked_balanced_account) { mock(Balanced::Account) }
  let(:mocked_market_place) { stub(cards_uri: cards_uri) }
  let(:mocked_credit_card) { mock(Balanced::Card) }

  [:expiration_month, :expiration_year, :card_number, :security_code, :name].each do |attr|
    it { should validate_presence_of attr }
  end

  describe '#save' do
    before do
      Balanced::Marketplace.should_receive(:my_marketplace).and_return(mocked_market_place)
      Balanced::Card.should_receive(:new).with(
        uri: cards_uri,
        expiration_month: credit_card.expiration_month,
        expiration_year: credit_card.expiration_year,
        security_code: credit_card.security_code,
        card_number: credit_card.card_number,
        name: credit_card.name
      ).and_return mocked_credit_card
    end

    context 'the credit_card is valid' do
      before do
        Balanced::Account.should_receive(:find).with(credit_card.user.balanced_account_uri).and_return(mocked_balanced_account)
        mocked_credit_card.should_receive(:save).and_return(mocked_credit_card)
        mocked_credit_card.should_receive(:uri).and_return('mocked_uri')
      end

      it 'should save the credit card' do
        mocked_balanced_account.should_receive(:add_card).with('mocked_uri')
        credit_card.save.should be_true
      end
    end

    context 'the credit_card misses information' do
      before do
        mocked_credit_card.should_receive(:save).and_raise(Balanced::BadRequest.new(body: { extras: { 'error' => 'description' } }))
      end

      it 'should return error messages' do
        credit_card.save.should be_false
        credit_card.errors.full_messages.should == ["Error description"]
      end
    end

    context 'the credit_card is invalid' do
      before do
        mocked_credit_card.should_receive(:save).and_raise(Balanced::Conflict.new(body: { extras: {}, description: 'description' }))
      end

      it 'should return error messages' do
        credit_card.save.should be_false
        credit_card.errors.full_messages.should == ["description"]
      end
    end
  end

  describe '#destroy' do
    context 'the credit_card exists' do
      before do
        Balanced::Card.should_receive(:find).with(credit_card.uri).and_return(mocked_credit_card)
      end

      it 'should invalidate the credit card' do
        mocked_credit_card.should_receive(:invalidate)
        credit_card.destroy.should be_true
      end
    end

    context 'the credit_card does not exists' do
      before do
        Balanced::Card.should_receive(:find).and_raise(Balanced::BadRequest.new(body: { extras: { 'error' => 'description' } }))
      end

      it 'should show error messages' do
        credit_card.destroy.should be_false
        credit_card.errors.full_messages.should == ["Error description"]
      end
    end
  end
end
