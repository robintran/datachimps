class Entry < ActiveRecord::Base
  attr_accessible :contest, :data_set_url, :description, :user

  ajaxful_rateable stars: 5, dimensions: [:quality, :amount, :speed], cache_column: :rating

  belongs_to :user
  belongs_to :contest

  has_many :feedbacks

  validates :contest, :user, :description, :data_set_url, presence: true

  validates :user_id, uniqueness: {scope: :contest_id, message: "cannot enter contest twice"}
end
