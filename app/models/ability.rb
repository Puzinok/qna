class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    alias_action :update, :destroy, to: :modify
    alias_action :vote_for, :vote_against, :vote_reset, to: :voting

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User, user: user
    can :users, User
    can :create, [Question, Answer, Comment, Subscription]
    can :modify, [Question, Answer], user: user

    can :destroy, Subscription, user_id: user.id

    can :voting, [Question, Answer] do |votable|
      votable.user != user
    end

    can :choose_best, Answer, question: { user_id: user.id }

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end
  end
end
