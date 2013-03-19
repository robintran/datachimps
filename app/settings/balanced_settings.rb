class BalancedSettings < Settingslogic
  source "#{Rails.root}/config/balanced.yml"
  namespace Rails.env
end
