class EnterController < ApplicationController
    before_action :authenticate_user!
    before_action :is_admin
  
    # GET /condominios or /condominios.json
    def index
      latitude = request.location.latitude.presence || 	41.8973103
      longitude = request.location.longitude.presence || 12.5131378
      if (params[:città].present?)
        comune = params[:città]
        @condominios = Condominio.where('lower(comune) = ?', comune.downcase)
     else
      @condominios = Condominio.near([latitude,longitude], params[:distanza].present? ? params[:distanza] : 100, units: :km,:order => :distance)
     end
    end

    def is_admin
      if current_user != nil && current_user.is_admin?
        redirect_to admin_index_path
      end
    end

    def new
      @request = Request.new
    end
  
    # POST /condominios or /condominios.json
    def create  
      @codice = params[:codice]
      respond_to do |format|
        if( !(Condominio.where(flat_code: @codice).exists?)) 
          format.html { redirect_to '/enter', notice: "Codice errato." }
          format.json {  render :show, status: :unprocessable_entity}
        elsif( Condomino.where(condominio_id: Condominio.find_by(flat_code: @codice).id, user_id: current_user.id).exists?) 
          format.html { redirect_to '/enter', notice: "Già iscritto a questo condominio." }
          format.json {  render :show, status: :unprocessable_entity}
        else
          @condominio = Condominio.find_by(flat_code: @codice).id
          @enter = Condomino.new(condominio_id: @condominio, user_id: current_user.id, is_condo_admin: false)
          @enter.save
          @Gdrive_controller = GdriveUserItemsController.new
          @Gdrive_controller.create(current_user.uname,current_user.email,@enter)
          if @Gdrive_controller
            format.html { redirect_to condominio_url(@condominio), notice: "Benvenuto nel condominio." }
          else 
            format.html { redirect_to condominio_url(@condominio), notice: "Benvenuto nel condominio, c'è stato un errore nella creazione della tua cartella Drive, contatta uno dei Leader condominio." }
          end
          format.json { render :show, status: :created, location: @condominio }         
        end
      end
    end
  
end
