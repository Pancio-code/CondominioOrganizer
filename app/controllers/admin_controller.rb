class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin
  def index
    if params[:nome] == nil || params[:nome] == ''
      @utenti = User.all
    else 
      @utenti = User.where("uname like ?", "%#{params[:nome]}%")
    end
    @condomini = Condominio.all
  end

  def is_admin
    if current_user != nil && !current_user.is_admin?
      redirect_to '/condominios', notice: 'Non hai i privilegi di Admin.'
    end
  end

  def eleva_ad_admin
    respond_to do |format|
      if User.find_by(id: params[:user_id]).update(is_admin: true)
        format.html { redirect_to condominio_condominos_path(Condominio.find_by(id: params[:condominio_id])), notice: User.find_by(id: params[:user_id]).uname + ' è diventato un amministratore del condominio.' }
        format.json { render :show, status: :ok, location: @condominio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @condomino.errors, status: :unprocessable_entity }
      end
    end
  end
end
