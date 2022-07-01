# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    anyone_abilities 

    if user
      if user.is_admin?
        admin_abilities
      else
        authenticated_abilities(user)
      end
    else
      guest_abilities
    end
  end

  private
    
    def anyone_abilities
      can :index, :all
    end

    def guest_abilities
      can :read, :sign_up
      can :read, Request do |r|
        r.requests.exists?(user_id: user.id)
    end

    def authenticated_abilities(user)
      can [:show,:update,:destroy], Condominio do |c|
        c.condominos.exists?(is_condo_admin: true, user_id: user.id)
      end
      can :show, Condominio
    end

    def admin_abilities
      # define abilities admins only
    end
end
