# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new # neu chua login
    if user.admin?
      can :manage, :all
      cannot :destroy, User, role: :admin
    else
      can [:index, :show], User
    end
  end
end
