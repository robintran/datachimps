module BalancedAccount
  def marketplace
    @_market_place ||= Balanced::Marketplace.my_marketplace
  end

  def balanced_account
    @_balanced_account ||= Balanced::Account.find(self.balanced_account_uri)
  end

  def credit_cards
    balanced_account.cards
  end

  def add_credit_card(card_info)
    cards_uri = marketplace.cards_uri
    card = Balanced::Card.new(card_info.merge(uri: cards_uri)).save
    balanced_account.add_card(card.uri)
    return true
  rescue Balanced::BadRequest => e
    self.errors[:base] << e.body["extras"]["description"]
    return false
  end

  def remove_credit_card(card_uri)
    card = Balanced::Card.find(card_uri)
    card.invalidate
    return true
  rescue Balanced::BadRequest => e
    self.errors[:base] << e.body["extras"]["description"]
    return false
  end

  def bank_accounts
    balanced_account.bank_accounts
  end

  def add_bank_account(bank_account_info)
    banks_uri = marketplace.bank_accounts_uri
    bank_account = Balanced::BankAccount.new(bank_account_info.merge(uri: banks_uri)).save
    balanced_account.add_bank_account(bank_account.uri)
    return true
  rescue Balanced::BadRequest => e
    self.errors[:base] << e.body["extras"]["description"]
    return false
  end

  def remove_bank_account(bank_account_uri)
    bank_account = Balanced::BankAccount.find(bank_account_uri)
    bank_account.destroy
    return true
  rescue Balanced::BadRequest => e
    self.errors[:base] << e.body["extras"]["description"]
    return false
  end

  def charge(amount_in_cents, opts = {})
    default_opts = {
      appears_on_statement_as: "Datachimp contest",
      amount: amount_in_cents,
      description: "You have created a contest on Datachimp and $#{amount_in_cents.to_f/100} is deducted from your account"
    }.merge(opts)
    balanced_account.debit(default_opts)
    return true
  rescue Balanced::BadRequest => e
    self.errors[:base] << e.body["extras"]["description"]
    return false
  end

  def credit(amount_in_cents)
    balanced_account.credit(amount_in_cents)
    return true
  rescue Balanced::BadRequest => e
    self.errors[:base] << e.body["extras"]["description"]
    return false
  end
end
