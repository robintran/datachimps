class User < ActiveRecord::Base
  ajaxful_rater
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :name, :balanced_account_uri

  has_many :contests
  has_many :won_contests, class_name: "Contest", foreign_key: :winner_id
  has_many :contest_followings, dependent: :destroy
  has_many :following_contests, source: :contest, through: :contest_followings

  after_create :create_balanced_account
  include ::BalancedAccount

  def self.find_for_facebook_oauth(auth)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name: auth.extra.raw_info.name,
                                   provider: auth.provider,
                                   uid: auth.uid,
                                   email: auth.info.email,
                                   password: Devise.friendly_token[0,20]
                                  )
    end
    user
  end

  def own?(contest)
    contest.user_id == self.id
  end

  def follow(contest)
    contest_followings.create(contest: contest)
  end

  def following?(contest)
    contest_followings.exists?(contest_id: contest.id)
  end

  def contest_following_for(contest)
    contest_followings.find_by_contest_id(contest.id)
  end

  private
  def create_balanced_account
    unless self.balanced_account_uri
      account = marketplace.create_account
      self.balanced_account_uri = account.uri
      self.save
    end
  end
end
