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
    @service.update_file(cartella_condominio_drive.id,add_parents: ENV[ 'DRIVE_ID' ])
    if email.sub(/.+@([^.]+).+/, '\1') == "gmail"
      @permesso_cartella = @service.create_permission(cartella_condominio_drive.id,Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"),send_notification_email: false)
    else 
      @permesso_cartella = @service.create_permission(cartella_condominio_drive.id,Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"),send_notification_email: true)
    end
    @Gdrive = GdriveCondoItem.new(folder_id: cartella_condominio_drive.id,condominio_id:condominio_id)
    if @Gdrive.save!
      return @permesso_cartella.id
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
#    file = File.read('config/google_credentials.json')
    
    @service = Google::Apis::DriveV3::DriveService.new
    scope = 'https://www.googleapis.com/auth/drive'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(ENV[ 'GOOGLE_CREDENTIALS' ]), scope: scope)
  
    authorizer.fetch_access_token!
    @service.authorization = authorizer

    return @service
  end

  def destroy(condominio_id)
    @service = initialize_drive_service
    @gdrive_condo_item = GdriveCondoItem.find_by(condominio_id: condominio_id)
    @f_id = @gdrive_condo_item.folder_id
    @user_items = GdriveUserItem.where(gdrive_condo_items_id: @gdrive_condo_item.id)
    @user_items.each do |useritem|
      useritem.destroy
    end
    @gdrive_condo_item.destroy
    begin 
      @service.delete_file(@f_id)
    rescue => e
      return false
    end

  end
end
