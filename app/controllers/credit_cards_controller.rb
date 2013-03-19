class CreditCardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @credit_cards = current_user.credit_cards

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @credit_cards }
    end
  end

  def new
    @credit_card = CreditCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @credit_card }
    end
  end

  def create
    @credit_card = CreditCard.new(params[:credit_card].merge(user: current_user))

    respond_to do |format|
      if @credit_card.save
        format.html { redirect_to credit_cards_path, notice: 'Credit card was successfully created.' }
        format.json { render json: @credit_card, status: :created, location: @credit_card }
      else
        format.html { render action: "new" }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @credit_card = CreditCard.new(uri: params[:uri])

    respond_to do |format|
      if @credit_card.destroy
        format.html { redirect_to credit_cards_path }
        format.json { head :no_content }
      else
        format.html { redirect_to credit_cards_path, notice: @credit_card.errors.full_messages.first }
        format.json { render json: @credit_card.errors, status: :unprocessable_entity }
      end
    end
  end
end
