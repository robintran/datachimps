class Entry < ActiveRecord::Base
  attr_accessible :contest, :data_set_url, :description, :user

  ajaxful_rateable stars: 5, dimensions: [:quality, :amount, :speed], cache_column: :rating

  belongs_to :user
  belongs_to :contest

  has_many :feedbacks

  validates :contest, :user, :description, :data_set_url, presence: true

  validates :user_id, uniqueness: {scope: :contest_id, message: "cannot enter contest twice"}

  validate :owner_has_account, :on => :create

  after_create :follow_contest

  def update_rating(rating)
    self.rating = rating
    self.save
  end

  private

  def owner_has_account
    errors.add(:base, "Owner must have an account to create a new entry.") unless user.balanced_account_uri.present?
  end

  def follow_contest
    user.follow(self.contest)
  end
end
