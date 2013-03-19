require 'spec_helper'

describe CreditCardsController do
  let(:user) { create(:user) }
  let(:mocked_credit_card) { mock(CreditCard) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    controller.stub(:current_user).and_return(user)
  end


  describe "GET index" do
    let!(:credit_cards) { build_list :credit_card, 1, user: user }

    before do
      user.stub(:credit_cards).and_return(credit_cards)
      get :index
    end

    it "assigns all credit_cards as @credit_cards" do
      assigns(:credit_cards).should =~ credit_cards
    end

    it 'should render template index' do
      response.should render_template('index')
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "assigns a new credit_card as @credit_card" do
      assigns(:credit_card).should be_a_new(CreditCard)
    end

    it 'should render template new' do
      response.should render_template('new')
    end
  end

  describe "POST create" do
    let(:credit_card_attributes) { attributes_for(:credit_card).except(:user) }

    before do
      CreditCard.should_receive(:new).with(
        credit_card_attributes.inject({}) do
          |params, (key, value)| params.update(key.to_s => value.to_s)
        end.merge('user' => user)
      ).and_return(mocked_credit_card)
    end

    describe "with valid params" do
      before do
        mocked_credit_card.should_receive(:save).and_return(true)
        post :create, credit_card: credit_card_attributes
      end

      it "redirects to the credit_cards_path" do
        response.should redirect_to(credit_cards_path)
        flash[:notice].should == 'Credit card was successfully created.'
      end
    end

    describe "with invalid params" do
      before do
        mocked_credit_card.should_receive(:save).and_return(false)
        post :create, credit_card: credit_card_attributes
      end

      it "re-renders the 'new' template" do
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    let(:uri) { 'credit_card_uri' }

    before do
      CreditCard.should_receive(:new).with(uri: uri).and_return(mocked_credit_card)
    end

    context 'valid credit_card' do
      before do
        mocked_credit_card.should_receive(:destroy).and_return true
        delete :destroy, id: 1, uri: uri
      end

      it 'should redirect to credit_cards_path with no notice' do
        response.should redirect_to credit_cards_path
        flash.should be_empty
      end
    end

    context 'invalid credit_card' do
      before do
        mocked_credit_card.should_receive(:destroy).and_return false
        mocked_credit_card.stub_chain(:errors, :full_messages, :first).and_return('error message')
        delete :destroy, id: 1, uri: uri
      end

      it 'should redirect to credit_cards_path with notice' do
        response.should redirect_to credit_cards_path
        flash[:notice].should == 'error message'
      end
    end
  end
end
