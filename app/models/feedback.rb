class Feedback < ActiveRecord::Base
  attr_accessible :content, :entry, :user

  belongs_to :entry
  belongs_to :user

  has_one :contest, through: :entry

  validates :content, presence: true
end
