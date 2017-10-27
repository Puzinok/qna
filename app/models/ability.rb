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
    can :create, [Question, Answer, Comment]
    can :modify, [Question, Answer], user: user
    can :voting, [Question, Answer] { |votable| votable.user != user }
    can :choose_best, Answer, question: { user_id: user.id }
  end
end
