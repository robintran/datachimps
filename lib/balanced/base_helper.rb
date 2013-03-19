module Balanced::BaseHelper
  def marketplace
    @_market_place ||= Balanced::Marketplace.my_marketplace
  end

  def balanced_account
    @_balanced_account ||= Balanced::Account.find(user.balanced_account_uri)
  end
end
