class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(resource)
    id == resource.user_id
  end
end
