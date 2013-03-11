class Contest < ActiveRecord::Base
  attr_accessible :bounty, :deadline, :description, :name, :user, :winner

  belongs_to :user
  belongs_to :winner, class_name: "User", foreign_key: :winner_id
  has_many :entries

  validates :bounty, :deadline, :description, :name, :user, presence: true
  after_create :create_bounty

  private
  def create_bounty
    # TODO
  end
end
