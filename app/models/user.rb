class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :oauth_providers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def author_of?(resource)
    id == resource.user_id
  end

  def self.find_for_oauth(auth)
    authorization = OauthProvider.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = if auth.info['email']
              auth.info['email']
            else
              "temp_email_#{auth.uid}@#{auth.provider}.com"
            end

    user = User.find_by(email: email)

    if user
      user.oauth_providers.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.oauth_providers.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end

  def email_verified?
    email && email !~ /\Atemp_email/
  end

  protected

  def confirmation_required?
    false
  end
end
