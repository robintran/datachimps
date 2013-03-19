require 'spec_helper'
describe BankAccountsController do
  let(:user) { create :user }
  let(:mocked_bank_account) { mock(BankAccount) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    controller.stub(:current_user).and_return(user)
  end

  describe "GET index" do
    let!(:bank_accounts) { build_list :bank_account, 1, user: user }

    before do
      user.stub(:bank_accounts).and_return(bank_accounts)
      get :index
    end

    it "assigns all bank_accounts as @bank_accounts" do
      assigns(:bank_accounts).should =~ bank_accounts
    end

    it 'should render template index' do
      response.should render_template('index')
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "assigns a new bank_account as @bank_account" do
      assigns(:bank_account).should be_a_new(BankAccount)
    end

    it 'should render template new' do
      response.should render_template('new')
    end
  end

  describe "POST create" do
    let(:bank_account_attributes) { attributes_for(:bank_account).except(:user) }

    before do
      BankAccount.should_receive(:new).with(
        bank_account_attributes.inject({}) do
          |params, (key, value)| params.update(key.to_s => value.to_s)
        end.merge('user' => user)
      ).and_return(mocked_bank_account)
    end

    describe "with valid params" do
      before do
        mocked_bank_account.should_receive(:save).and_return(true)
        post :create, bank_account: bank_account_attributes
      end

      it "redirects to the bank_accounts_path" do
        response.should redirect_to(bank_accounts_path)
        flash[:notice].should == 'Bank account was successfully created.'
      end
    end

    describe "with invalid params" do
      before do
        mocked_bank_account.should_receive(:save).and_return(false)
        post :create, bank_account: bank_account_attributes
      end

      it "re-renders the 'new' template" do
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    let(:uri) { 'bank_account_uri' }

    before do
      BankAccount.should_receive(:new).with(uri: uri).and_return(mocked_bank_account)
    end

    context 'valid bank_account' do
      before do
        mocked_bank_account.should_receive(:destroy).and_return true
        delete :destroy, id: 1, uri: uri
      end

      it 'should redirect to bank_accounts_path with no notice' do
        response.should redirect_to bank_accounts_path
        flash.should be_empty
      end
    end

    context 'invalid bank_account' do
      before do
        mocked_bank_account.should_receive(:destroy).and_return false
        mocked_bank_account.stub_chain(:errors, :full_messages, :first).and_return('error message')
        delete :destroy, id: 1, uri: uri
      end

      it 'should redirect to bank_accounts_path with notice' do
        response.should redirect_to bank_accounts_path
        flash[:notice].should == 'error message'
      end
    end
  end
end
