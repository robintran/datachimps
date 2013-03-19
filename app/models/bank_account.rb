class BankAccount < BalancedModel
  attr_accessor :name, :account_number, :routing_number, :bank_name, :account_number, :type, :uri, :bank_name, :user
  validates :name, :account_number, :routing_number, :type, presence: true

  def save
    bank_account = Balanced::BankAccount.new(
      bank_uri: marketplace.bank_accounts_uri,
      type: type,
      name: name,
      account_number: account_number,
      routing_number: routing_number
    ).save
    balanced_account.add_bank_account(bank_account.uri)
    return true
  rescue Exception => exception
    rescue_with_handler(exception) || raise
    return false
  end

  def destroy
    bank_account = Balanced::BankAccount.find(uri)
    bank_account.destroy
    return true
  rescue Exception => exception
    rescue_with_handler(exception) || raise
    return false
  end
end
