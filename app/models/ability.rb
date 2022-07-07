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
    end

    def authenticated_abilities(user)
      can [:new,:create,:show,:update,:destroy], Condominio do |c|
        c.condominos.exists?(is_condo_admin: true, user_id: user.id)
      end
      can :Destroy, Post do |p|
        p.user_id == user.id or Post.where("EXISTS(SELECT 1 from condominos where condominos.condominio_id = (?) AND condominos.user_id = (?) AND condominos.is_condo_admin = true) ",p.condominio_id,user.id).exists?
      end
      can :edit, Request do |r|
        Request.where("EXISTS(SELECT 1 from condominos where condominos.condominio_id = (?) AND condominos.user_id = (?) AND condominos.is_condo_admin = true) ",r.condominio_id,user.id).exists?
      end
      can [:new,:create,:show], Condominio
    end

    def admin_abilities
      can :Destroy, Post
    end
end

