class ContestFollowing < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user

  attr_accessible :contest, :contest_id

  validates_uniqueness_of :user_id, scope: :contest_id
  validates :user_id, :contest_id, presence: true
end
