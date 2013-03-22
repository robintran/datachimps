class Entry < ActiveRecord::Base
  attr_accessible :contest, :data_set_url, :description, :user

  ajaxful_rateable stars: 5, dimensions: [:quality, :amount, :speed], cache_column: :rating

  belongs_to :user
  belongs_to :contest

  has_many :feedbacks

  validates :contest, :user, :description, :data_set_url, presence: true

  validates :user_id, uniqueness: {scope: :contest_id, message: "cannot enter contest twice"}

  validate :owner_has_account, :contest_not_expired, :own_contest, :on => :create

  after_create :follow_contest

  scope :active, where(removed: false)

  def remove
    self.removed = true
    self.save
  end

  def headline
    "#{user.email} - #{description.try(:[], 0..10)}"
  end

  private

  def own_contest
    errors.add(:base, "Cannot enter your own contest.") if contest.user == self.user
  end

  def contest_not_expired
    errors.add(:base, "The contest is expired.") if contest.expired?
  end

  def owner_has_account
    errors.add(:base, "Owner must have an account to create a new entry.") unless user.balanced_account_uri.present?
  end

  def follow_contest
    user.follow(self.contest)
  end
end
