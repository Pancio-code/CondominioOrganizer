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
      # define abilities for everyone, both logged users and visitors
    end

    def guest_abilities
      can :read, :sign_up
    end

    def authenticated_abilities(user)
      can :show, Condominio do |c|
        c.condominos.exists?(is_condo_admin: true, user_id: user.id)
      end
    end

    def admin_abilities
      # define abilities admins only
    end
end
