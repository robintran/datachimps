class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :name

  has_many :contests
  has_many :won_contests, class_name: "Contest", foreign_key: :winner_id

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
end
