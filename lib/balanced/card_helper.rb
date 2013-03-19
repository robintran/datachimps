module Balanced::CardHelper
  include Balanced::BaseHelper

  def add_credit_card
    card = Balanced::Card.new(
      uri: marketplace.cards_uri,
      expiration_month: expiration_month,
      expiration_year: expiration_year,
      security_code: security_code,
      card_number: card_number
    ).save
    balanced_account.add_card(card.uri)
    return true
  rescue Balanced::Error => e
    e.body["extras"].map { |k, v| errors.add(k,v) }
    errors[:base] << e.description if errors.empty?
    return false
  end

  def remove_credit_card
    card = Balanced::Card.find(uri)
    card.invalidate
    return true
  rescue Balanced::Error => e
    self.errors[:base] << e.body["extras"]["description"]
    return false
  end
end
