class GdriveCondoItemsController < ApplicationController
  before_action :authenticate_user!

  # GET /gdrive_condo_items or /gdrive_condo_items.json
  def index
    @gdrive_condo_items = GdriveCondoItem.all
  end

  # POST /gdrive_condo_items or /gdrive_condo_items.json
  def create(nome,email,condominio_id)
    @service = initialize_drive_service

    cartella_condominio = Google::Apis::DriveV3::File.new(name: nome,mime_type: "application/vnd.google-apps.folder")
    cartella_condominio_drive = @service.create_file(cartella_condominio)
    @service.update_file(cartella_condominio_drive.id,add_parents: Figaro.env.drive_id)
    permesso_cartella = Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user")
    @service.create_permission(cartella_condominio_drive.id,permesso_cartella)
    @Gdrive = GdriveCondoItem.new(folder_id: cartella_condominio_drive.id,condominio_id:condominio_id)
    if @Gdrive.save!
      return permesso_cartella.id
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

    @service = initialize_drive_service

    cartella_condominio = @service.delete_file(file_id: @gdrive_condo_item.folder_id)

    @gdrive_condo_item.destroy

    respond_to do |format|
      format.html { redirect_to gdrive_condo_items_url, notice: "Gdrive condo item was successfully destroyed." }
      format.json { head :no_content }
    end
  end
end
