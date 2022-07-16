class CondominosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_condomino, only: %i[ show edit update destroy ]

  # GET /condominos or /condominos.json
  def index
    @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
    @condomini = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: false)
    @condomini_amm = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: true)
    authorize! :index, Condomino
  end

  def eleva_condomino
    authorize! :destroy, Condominio
    respond_to do |format|
      if Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:user_id]).update(is_condo_admin: true)
        utente = User.find(params[:user_id])
        @Gdrive_controller = GdriveUserItemsController.new
        @Gdrive_controller.update(params[:condominio_id],params[:user_id],"eleva",nil)
        format.html { redirect_to condominio_condominos_path(Condominio.find_by(id: params[:condominio_id])), notice: User.find_by(id: params[:user_id]).uname + ' è diventato un amministratore del condominio.' }
        format.json { render :show, status: :ok, location: @condominio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @condomino.errors, status: :unprocessable_entity }
      end
    end
  end

  def cedi_ruolo_leader
    authorize! :destroy, Condominio
    respond_to do |format|
      if params.has_key?(:condominio_id) && params.has_key?(:old_amministratore_id) && params.has_key?(:new_amministratore_id)
        @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
        if Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:old_amministratore_id]).update(is_condo_admin: false) && Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:new_amministratore_id]).update(is_condo_admin: true)
          @Gdrive_controller = GdriveUserItemsController.new
          @Gdrive_controller.update(params[:condominio_id],params[:old_amministratore_id],"scegli",params[:new_amministratore_id])
          format.html { redirect_to condominio_condominos_path(@condominio_attuale), notice: User.find_by(id: params[:new_amministratore_id]).uname + ' è il nuovo amministratore del condominio.' }
          format.json { render :show, status: :ok, location: @condominio_attuale }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @condominio_attuale.errors, status: :unprocessable_entity }
        end
      else 
        @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
        if Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:old_amministratore_id]).update(is_condo_admin: false)
          @Gdrive_controller = GdriveUserItemsController.new
          @Gdrive_controller.update(params[:condominio_id],params[:old_amministratore_id],"cedi",nil)
          format.html { redirect_to condominio_condominos_path(@condominio_attuale), notice: User.find_by(id: params[:old_amministratore_id]).uname + ' non è più un amministratore del condominio.' }
          format.json { render :show, status: :ok, location: @condominio_attuale }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @condominio_attuale.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def choose_new_leader
    authorize! :destroy, Condominio
    if params.has_key?(:condominio_id) && params.has_key?(:old_amministratore_id)
      @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
      @condomini = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: false)
      @condominio_amministratore = params[:old_amministratore_id]
    else
      redirect_to root_path, :alert => "Parametri errati"
    end
  end

  # GET /condominos/1 or /condominos/1.json
  #def show
  #end
  def get_comunicazione_del_leader
    authorize! :destroy, Condominio
    @condominio = Condominio.find(params[:condominio_id])
    @condomini = Condomino.where(condominio_id: params[:condominio_id])
  end

  def post_comunicazione_del_leader
    authorize! :destroy, Condominio
    if params.has_key?(:commit) && params.has_key?(:message) && params.has_key?(:user_select_email)
      if params[:commit] == 'Invia a tutti'
        @condomini_all = Condomino.where(condominio_id: params[:condominio_id])
        if current_user.from_oauth?
          session_time = Time.now - session[:time_login].to_datetime
          require 'json' 
          token, refresh_token = *JSON.parse(File.read('credentials.data'))
          #client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'gmail.send')
          client = Signet::OAuth2::Client.new(client_id: ENV['GOOGLE_API_ID'],client_secret: ENV['GOOGLE_API_SECRET'],access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'gmail.send')

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

          @condomini_all.each do |condomino|
            if condomino.user_id != current_user.id
             @condomino_corrente = User.find(condomino.user_id)
             m = Mail.new(
               to: @condomino_corrente.email, 
               from: current_user.email, 
               subject: "Comunicazione dall'amministratore del condominio:",
               body: params[:message])
             message_object = Google::Apis::GmailV1::Message.new(raw: m.encoded) 
             service.send_user_message('me', message_object)
            end
          end
          redirect_to condominio_condominos_path(Condominio.find(params[:condominio_id])), :notice => "Comunicazione inviata correttamente a tutti i condomini."
        else
          @condomini_all.each do |condomino| 
            @condomino_corrente = User.find(condomino.user_id)
            @condominio_mailer = Condominio.find(params[:condominio_id])
            CondominioMailer.with(name: current_user.uname, email: @condomino_corrente.email, condominio: @condominio_mailer.nome, message: params[:message]).new_comunication_for_condomini_mailer.deliver_later
          end
          redirect_to condominio_condominos_path(Condominio.find(params[:condominio_id])), :notice => "Comunicazione inviata correttamente a tutti i condomini."
        end
      else
        if current_user.from_oauth?
          session_time = Time.now - session[:time_login].to_datetime
          require 'json' 
          token, refresh_token = *JSON.parse(File.read('credentials.data'))
          client = Signet::OAuth2::Client.new(client_id: ENV['GOOGLE_API_ID'],client_secret: ENV['GOOGLE_API_SECRET'],access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'gmail.send')
  
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

          params[:user_select_email].each do |email| 
            m = Mail.new(
              to: email, 
              from: current_user.email, 
              subject: "Comunicazione dall'amministratore del condominio:",
              body: params[:message])
            message_object = Google::Apis::GmailV1::Message.new(raw: m.encoded) 
            service.send_user_message('me', message_object)
          end
          redirect_to condominio_condominos_path(Condominio.find(params[:condominio_id])), :notice => "Comunicazione inviata correttamente ai condomini selezionati."
        else
          @condominio_mailer = Condominio.find(params[:condominio_id])
          params[:user_select_email].each do |email| 
            CondominioMailer.with(name: current_user.uname, email: email, condominio: @condominio_mailer.nome, message: params[:message]).new_comunication_for_condomini_mailer.deliver_later
          end
          
          redirect_to condominio_condominos_path(Condominio.find(params[:condominio_id])), :notice => "Comunicazione inviata correttamente ai condomini selezionati."
        end
      end
    else
      redirect_back(fallback_location: root_path, :notice => "Parametri mancanti o errati")
    end
  end

  # GET /condominos/new
  def new
    authorize! :destroy, Condominio
    @condominio_attuale = Condominio.find(params[:id])
  end

  # GET /condominos/1/edit
  def edit
  end

  # POST /condominos or /condominos.json
  def create
    authorize! :destroy, Condominio
    if params.has_key?(:email) && params.has_key?(:codice) && params.has_key?(:condominio_id)
      if current_user.from_oauth?
        session_time = Time.now - session[:time_login].to_datetime
        @condominio_condiviso = Condominio.find(params[:condominio_id])
        require 'json' 
        token, refresh_token = *JSON.parse(File.read('credentials.data'))
        #client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'gmail.send')
        client = Signet::OAuth2::Client.new(client_id: ENV['GOOGLE_API_ID'],client_secret: ENV['GOOGLE_API_SECRET'],access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'gmail.send')

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
          subject: "Codice d'invito per entrare nel condominio:",
          body: "il codice d'accesso del " + @condominio_condiviso.nome + " è " + params[:codice])
        message_object = Google::Apis::GmailV1::Message.new(raw: m.encoded) 
        service.send_user_message('me', message_object)
        redirect_to condominio_condominos_path(@condominio_condiviso), :notice => "Codice condiviso correttamente dal tuo account Gmail."
      else
        @condominio_codice = Condominio.find(params[:condominio_id])
        CondominioMailer.with(name: current_user.uname, email: params[:email], condominio:  @condominio_codice.nome,comune:  @condominio_codice.comune ,via:  @condominio_codice.indirizzo, message: "il codice d'invito del condominio è : " + params[:codice]).new_comunication_mailer.deliver_later
        redirect_to condominio_url(@condominio_codice), :notice => "Codice condiviso correttamente."
      end
    else
      redirect_to new_condomino_path(params[:condominio_id]), :notice => "Errore nella condivisione del codice."
    end
  end

  # PATCH/PUT /condominos/1 or /condominos/1.json
  def update
    respond_to do |format|
      if @condomino.update(condomino_params)
        format.html { redirect_to condomino_url(@condomino), notice: "Condomino was successfully updated." }
        format.json { render :show, status: :ok, location: @condomino }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @condomino.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /condominos/1 or /condominos/1.json
  def destroy
    authorize! :destroy, Condominio
    @condomino = Condomino.find(params[:id])
    @utente_id = @condomino.user_id
    id_cartella_condominio = GdriveCondoItem.find_by(condominio_id: @condomino.condominio_id).id
    @condominio = Condominio.find_by(id: @condomino.condominio_id)
    @Gdrive_controller = GdriveUserItemsController.new
#   @Gdrive_controller.destroy(@condomino.id)
    @Gdrive_controller.destroy(@condomino.id,id_cartella_condominio)
    @condomino.destroy


    respond_to do |format|
      if @utente_id == current_user.id
        format.html { redirect_to root_path, notice: "Uscito correttamente dal condominio." }
        format.json { head :no_content }
      else
        format.html { redirect_to condominio_condominos_path(@condominio), notice: "Membro espulso correttamente." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_condomino
      @condomino = Condomino.find(params[:id])
    end

    def condomino_params
      params.require(:condomino).permit(:condomino_id, :user_id)
    end
end
