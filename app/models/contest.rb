class Contest < ActiveRecord::Base
  attr_accessible :bounty, :deadline, :description, :name, :user, :winner, :winner_id

  belongs_to :user
  belongs_to :winner, class_name: "Entry", foreign_key: :winner_id
  has_many :entries
  has_many :contestants, source: :user, through: :entries
  has_many :contest_followings, dependent: :destroy
  has_many :users, through: :contest_followings

  validates :bounty, :deadline, :description, :name, :user, presence: true
  validate :owner_has_account, :on => :create
  after_create :create_bounty, :follow_contest

  def pick_winner(win_entry)
    return false if self.winner || win_entry.removed
    self.update_attributes(winner: win_entry)
    win_entry.user.credit(bounty * 0.9 * 100)
    return true
  end

  def expired?
    winner.present? || deadline <= Time.now
  end

  private
  def owner_has_account
    errors.add(:base, "Owner must have a credit card to create a new contest.") unless user.credit_cards.any?
  end

  def create_bounty
    user.charge(bounty)
  end

  def follow_contest
    user.follow(self)
  end
end
