class Contest < ActiveRecord::Base
  attr_accessible :bounty, :deadline, :description, :name, :user, :winner, :winner_id

  belongs_to :user
  belongs_to :winner, class_name: "Entry", foreign_key: :winner_id
  has_many :entries
  has_many :contest_followings, dependent: :destroy
  has_many :users, through: :contest_followings

  validates :bounty, :deadline, :description, :name, :user, presence: true
  validate :owner_has_account, :on => :create
  after_create :create_bounty, :follow_contest
  before_save :update_winner, :if => :winner_id_changed?

  def expired?
    winner.present? || passed_deadline?
  end

  def passed_deadline?
    deadline <= Time.now
  end

  def pick_winner(win_entry)
    return false if self.winner || win_entry.removed
    self.update_attributes(winner: win_entry)
    win_entry.user.credit(bounty * 0.9 * 100)
    return true
  end

  private
  def update_winner
    if winner_id_was || winner.removed
      self.winner_id = winner_id_was
    else
      winner.user.credit(bounty * 0.9 * 100)
    end
  end

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
