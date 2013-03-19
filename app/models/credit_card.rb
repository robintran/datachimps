class CreditCard < BalancedModel
  attr_accessor :card_number, :security_code, :expiration_month, :expiration_year, :uri, :user, :name
  validates :expiration_month, :expiration_year, :card_number, :security_code, :name,  presence: true

  def save
    card = Balanced::Card.new(
      uri: marketplace.cards_uri,
      expiration_month: expiration_month,
      expiration_year: expiration_year,
      security_code: security_code,
      card_number: card_number,
      name: name
    ).save
    balanced_account.add_card(card.uri)
    return true
  rescue Exception => exception
    rescue_with_handler(exception) || raise
    return false
  end

  def destroy
    card = Balanced::Card.find(uri)
    card.invalidate
    return true
  rescue Exception => exception
    rescue_with_handler(exception) || raise
    return false
  end
end
