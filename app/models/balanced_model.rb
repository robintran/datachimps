class BalancedModel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveSupport::Rescuable
  include Balanced::BaseHelper
  extend ActiveModel::Naming

  rescue_from Balanced::Error, with: :invalidate_object

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def new_record?
    true
  end

  def persisted?
    false
  end

  private

  def invalidate_object exception
    exception.body["extras"].map { |k, v| errors.add(k,v) } if exception.body.try(:[], 'extras')
    errors[:base] << exception.description if errors.empty?
  end
end
