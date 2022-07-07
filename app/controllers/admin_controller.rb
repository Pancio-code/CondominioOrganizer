class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin
  def index
    @utenti = User.all
    @condomini = Condominio.all
  end

  def is_admin
    if current_user != nil && !current_user.is_admin?
      redirect_to '/condominios', notice: 'Non hai i privilegi di Admin.'
    end
  end

  def eleva_amministratore
    
  end
end
