class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin
  def index
    if params[:nome] == nil || params[:nome] == ''
      @utenti = User.all.order(:uname)
    else 
      @utenti = User.where("uname like ?", "%#{params[:nome]}%").order(:uname)
    end
    @numero_admin = User.where(is_admin: true).count
    @numero_amministratori = Condomino.where(is_condo_admin: true).group_by(&:user_id).count
    @condomini = Condominio.all
    @numero_richieste = Request.all.count
    @numero_posts = Post.all.count
    @numero_comments = Comment.all.count
  end

  def is_admin
    if current_user != nil && !current_user.is_admin?
      redirect_to '/condominios', notice: 'Non hai i privilegi di Admin.'
    end
  end

  def eleva_ad_admin
    respond_to do |format|
      if User.find_by(id: params[:user_id]).update(is_admin: true)
        format.html { redirect_to admin_index_path, notice: User.find_by(id: params[:user_id]).uname + ' è diventato un Admin del sito.' }
        format.json { render :show, status: :ok, location: @condomini }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @condomini.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_index_path, notice: "L'utente è stato cancellato." }
      format.json { head :no_content }
    end
  end
end
