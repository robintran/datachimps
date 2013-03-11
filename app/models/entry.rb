class Entry < ActiveRecord::Base
  attr_accessible :contest, :data_set_url, :description, :user

  belongs_to :user
  belongs_to :contest

  has_many :feedbacks

  validates :contest, :user, :description, :data_set_url, presence: true

  validates :rating, inclusion: {in: 1..5}, if: Proc.new {|entry| entry.rating.present?}

  validates :user_id, uniqueness: {scope: :contest_id, message: "cannot enter contest twice"}

  def update_rating(rating)
    self.rating = rating
    self.save
  end
end
