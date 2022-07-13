class GdriveUserItemsController < ApplicationController
  before_action :authenticate_user!

  def initialize_drive                                              
    file = File.read('config/google_credentials.json')
    
    @service = Google::Apis::DriveV3::DriveService.new
    scope = 'https://www.googleapis.com/auth/drive'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(file), scope: scope)
  
    authorizer.fetch_access_token!
    @service.authorization = authorizer

    return @service
  end

  # POST /gdrive_user_items or /gdrive_user_items.json
  def create(nome,email,condomino)
    @service = initialize_drive
    
    cartella_utente = Google::Apis::DriveV3::File.new(name: nome,mime_type: "application/vnd.google-apps.folder")
    cartella_condominio = GdriveCondoItem.find_by(condominio_id: condomino.condominio_id)
    cartella_utente_drive = @service.create_file(cartella_utente)
    @service.update_file(cartella_utente_drive.id,add_parents: cartella_condominio.folder_id)
    @service.create_permission(cartella_utente_drive.id,Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"))

    @gdrive_user_item = GdriveUserItem.new()

    @gdrive_user_item.folder_id = cartella_utente_drive.id
    @gdrive_user_item.condomino_id = condomino.id
    @gdrive_user_item.gdrive_condo_items_id = cartella_condominio.id

    if @gdrive_user_item.save!
      return true
    else
      return false
    end
  end

  # PATCH/PUT /gdrive_user_items/1 or /gdrive_user_items/1.json
  def update(condominio,condomino,email,evento)
    @service = initialize_drive
    
    if evento = "eleva"

    elsif evento = "cedi"

    else 

    end
  end

  # DELETE /gdrive_user_items/1 or /gdrive_user_items/1.json
  def destroy(condomino_id,gdrive_condo_items_id)
    @gdrive_user_item = GdriveUserItem.find_by(condomino_id: condomino_id,gdrive_condo_items_id: gdrive_condo_items_id)
    @service = initialize_drive

    begin 
      @service.delete_file(@gdrive_user_item.folder_id)
    rescue => e
      if !e.status_code == 404
        redirect_to root_path, :alert => e.message
        return false
      end
    end
    @gdrive_user_item.destroy
  end
end
