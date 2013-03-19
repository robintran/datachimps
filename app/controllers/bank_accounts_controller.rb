class BankAccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @bank_accounts = current_user.bank_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bank_accounts }
    end
  end

  def new
    @bank_account = BankAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bank_account }
    end
  end

  def create
    @bank_account = BankAccount.new(params[:bank_account].merge(user: current_user))

    respond_to do |format|
      if  @bank_account.save
        format.html { redirect_to bank_accounts_path, notice: 'Bank account was successfully created.' }
        format.json { render json: @bank_account, status: :created, location: @bank_account }
      else
        format.html { render action: "new" }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bank_account = BankAccount.new(uri: params[:uri])

    respond_to do |format|
      if @bank_account.destroy
        format.html { redirect_to bank_accounts_path }
        format.json { head :no_content }
      else
        format.html { redirect_to bank_accounts_path, notice: @bank_account.errors.full_messages.first }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

end
