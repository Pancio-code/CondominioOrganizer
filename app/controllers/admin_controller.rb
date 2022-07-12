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
    authorize! :index, User
  end

  def is_admin
    if current_user != nil && !current_user.is_admin?
      redirect_to '/condominios', notice: 'Non hai i privilegi di Admin.'
    end
  end

  def eleva_ad_admin
    authorize! :eleva_ad_admin, User
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

  def create_comunication_for_leader
    authorize! :create_comunication_for_leader, User
    @condomini = Condomino.where(is_condo_admin: true).distinct(:user_id).order(:uname)
  end

  def comunication_for_leader
    authorize! :comunication_for_leader, User
    if params.has_key?(:email) && params.has_key?(:message)
      if current_user.from_oauth?
        session_time = Time.now - session[:time_login].to_datetime
        require 'json' 
        token, refresh_token = *JSON.parse(File.read('credentials.data'))
        client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'gmail.send')
        if client.expired? || (session_time/60).to_i > 28
          session[:time_login] = Time.now 
          new_token = client.refresh!
          @new_tokens =
            {
              :access_token  => new_token["access_token"],
              :refresh_token => new_token["refresh_token"]
            }
        
          client.access_token  = @new_tokens[ :access_token ]
          client.refresh_token = @new_tokens[ :refresh_token ]
          File.write 'credentials.data', [client.access_token, client.refresh_token].to_json
        end
        service = Google::Apis::GmailV1::GmailService.new
        service.authorization = client
        m = Mail.new(
          to: params[:email], 
          from: current_user.email, 
          subject: "Comunicazione dall' Admin di CondominioOrganizer:",
          body: params[:message])
        message_object = Google::Apis::GmailV1::Message.new(raw: m.encoded) 
        service.send_user_message('me', message_object)
        redirect_to admin_index_path, :notice => "Mail inviata correttamente al Leader condominio."
      else
        CondominioMailer.with(name: current_user.uname, email: params[:email], condominio: params[:nome], message: params[:message]).new_comunication_for_leader_mailer.deliver_later
        redirect_to admin_index_path, :notice => "Mail inviata correttamente al Leader condominio."
      end
    else
      redirect_to admin_create_comunication_for_leader_path, :notice => "Parametri errati o errore nell'invio al server."
    end
  end

  def destroy
    authorize! :destroy, User
    User.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_index_path, notice: "L'utente è stato cancellato." }
      format.json { head :no_content }
    end
  end
end
