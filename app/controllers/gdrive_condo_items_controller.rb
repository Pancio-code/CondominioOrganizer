class GdriveCondoItemsController < ApplicationController
  before_action :set_gdrive_condo_item, only: %i[ show edit update destroy ]

  # GET /gdrive_condo_items or /gdrive_condo_items.json
  def index
    @gdrive_condo_items = GdriveCondoItem.all
  end

  # GET /gdrive_condo_items/1 or /gdrive_condo_items/1.json
  def show
  end

  # GET /gdrive_condo_items/new
  def new
    @gdrive_condo_item = GdriveCondoItem.new
  end

  # GET /gdrive_condo_items/1/edit
  def edit
  end

  # POST /gdrive_condo_items or /gdrive_condo_items.json
  def create
    @service = @gdrive_condo_item.initialize_drive_service

    cartella_condominio_drive = Google::Apis::DriveV3::File.new(name: nome,mime_type: "application/vnd.google-apps.folder")
    cartella_condominio_drive = @service.create_file(cartella_condominio_drive)
    @service.update_file(cartella_condominio_drive.id, add_parents: Figaro.env.drive_id)
    @service.create_permission(cartella_condominio_drive.id, Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"))

    @gdrive_condo_item = GdriveCondoItem.new(gdrive_condo_item_params)
    puts cartella_condominio_drive.id
    @gdrive_condo_item.folder_id = cartella_condominio_drive.id

    respond_to do |format|
      if @gdrive_condo_item.save!
        puts 'CONDO FOLDER CREATA CON SUCCESSO'
      else
        puts 'IMPOSSIBILE CREARE CONDO FOLDER'
      end
    end
  end

  # PATCH/PUT /gdrive_condo_items/1 or /gdrive_condo_items/1.json
  def update
    respond_to do |format|
      if @gdrive_condo_item.update(gdrive_condo_item_params)
        format.html { redirect_to gdrive_condo_item_url(@gdrive_condo_item), notice: "Gdrive condo item was successfully updated." }
        format.json { render :show, status: :ok, location: @gdrive_condo_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gdrive_condo_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def initialize_drive_service

    file = File.read('config/google_credentials.json')
                   
    @service = Google::Apis::DriveV3::DriveService.new
    scope = 'https://www.googleapis.com/auth/drive'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(file), scope: scope)
  
    authorizer.fetch_access_token!
    @service.authorization = authorizer
    return @service

  end

  # DELETE /gdrive_condo_items/1 or /gdrive_condo_items/1.json
  def destroy

    @service = @gdrive_condo_item.initialize_drive_service

#    cartella_condominio = Google::Apis::DriveV3::File.destroy(file_id: @gdrive_condo_item.folder_id)
    cartella_condominio = @service.delete_file(file_id: @gdrive_condo_item.folder_id)

    @gdrive_condo_item.destroy

    respond_to do |format|
      format.html { redirect_to gdrive_condo_items_url, notice: "Gdrive condo item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gdrive_condo_item
      @gdrive_condo_item = GdriveCondoItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gdrive_condo_item_params
      params.require(:gdrive_condo_item).permit( :condominio_id)
    end
end
