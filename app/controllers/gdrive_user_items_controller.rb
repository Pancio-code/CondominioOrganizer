class GdriveUserItemsController < ApplicationController
  before_action :authenticate_user!

  def initialize_drive                                              
#   file = File.read('config/google_credentials.json')
    
    @service = Google::Apis::DriveV3::DriveService.new
    scope = 'https://www.googleapis.com/auth/drive'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(ENV[ 'GOOGLE_CREDENTIALS' ]), scope: scope)
  
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
    if email.sub(/.+@([^.]+).+/, '\1') == "gmail" && email.sub(/.+@([^.]+).([^.]+).+/, '\2') == "com"
      @service.create_permission(cartella_utente_drive.id,Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"),send_notification_email: false)
    else 
      @service.create_permission(cartella_utente_drive.id,Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"),send_notification_email: true)
    end

    @gdrive_user_item = GdriveUserItem.new()

    @gdrive_user_item.folder_id = cartella_utente_drive.id
    @gdrive_user_item.condomino_id = condomino.id
    @gdrive_user_item.gdrive_condo_items_id = cartella_condominio.id

    condomino.update(folder_id: cartella_utente_drive.id)
    condomino.save

    if @gdrive_user_item.save!
      return cartella_utente_drive.id
    else
      return false
    end
  end

  def crea_file(path, email, condomino)
    @service = initialize_drive
    
    file_utente = Google::Apis::DriveV3::File.new(name: path.original_filename)
#   cartella_condominio = GdriveCondoItem.find_by(condominio_id: condomino.condominio_id)
    @cartella_utente = condomino.folder_id
#    abort path.inspect
    file_utente_drive = @service.create_file(file_utente, upload_source: path.tempfile, content_type: path.content_type)
    @service.update_file(file_utente_drive.id, add_parents: @cartella_utente)

    if email.sub(/.+@([^.]+).+/, '\1') == "gmail" && email.sub(/.+@([^.]+).([^.]+).+/, '\2') == "com"
      @service.create_permission(condomino.folder_id,Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"),send_notification_email: false)
    else 
      @service.create_permission(condomino.folder_id,Google::Apis::DriveV3::Permission.new(email_address: email,role: "writer",type: "user"),send_notification_email: true)
    end

    @gdrive_user_item = GdriveFileItem.new()

    @gdrive_user_item.file_id = file_utente_drive.id
    @gdrive_user_item.gdrive_user_item_id = GdriveUserItem.find_by(condomino_id: condomino.id,folder_id:condomino.folder_id).id

    if @gdrive_user_item.save!
      return true
    else
      return false
    end
  end

  def inserisci_file(path,condomini)
    @service = initialize_drive
    
    condomini.each do |condomino|
      condomino_attuale = Condomino.find(condomino)
      utente = User.find(condomino_attuale.user_id)
      file_utente = Google::Apis::DriveV3::File.new(name: path.original_filename)
  #   cartella_condominio = GdriveCondoItem.find_by(condominio_id: condomino.condominio_id)
      @cartella_utente = condomino_attuale.folder_id
  #    abort path.inspect
      file_utente_drive = @service.create_file(file_utente, upload_source: path.tempfile, content_type: path.content_type)
      @service.update_file(file_utente_drive.id, add_parents: @cartella_utente)

      if utente.email.sub(/.+@([^.]+).+/, '\1') == "gmail" && utente.email.sub(/.+@([^.]+).([^.]+).+/, '\2') == "com"
        @service.create_permission(condomino_attuale.folder_id,Google::Apis::DriveV3::Permission.new(email_address: utente.email,role: "writer",type: "user"),send_notification_email: false)
      else 
        @service.create_permission(condomino_attuale.folder_id,Google::Apis::DriveV3::Permission.new(email_address: utente.email,role: "writer",type: "user"),send_notification_email: true)
      end

      @gdrive_user_item = GdriveFileItem.new()

      @gdrive_user_item.file_id = file_utente_drive.id
      @gdrive_user_item.gdrive_user_item_id = GdriveUserItem.find_by(condomino_id: condomino,folder_id: condomino_attuale.folder_id).id
    
    end

    return true
  end

  # PATCH/PUT /gdrive_user_items/1 or /gdrive_user_items/1.json
  def update(condominio_id,user_id,evento,nuovo_user_id)
    @service = initialize_drive
    utente = User.find_by(id: user_id)
    cartella_condominio = GdriveCondoItem.find_by(condominio_id: condominio_id)
    if evento == "eleva"
      if utente.email.sub(/.+@([^.]+).+/, '\1') == "gmail" && utente.email.sub(/.+@([^.]+).([^.]+).+/, '\2') == "com"
        permesso_condominio = @service.create_permission(cartella_condominio.folder_id,Google::Apis::DriveV3::Permission.new(email_address: utente.email,role: "writer",type: "user"),send_notification_email: false)
      else 
        permesso_condominio = @service.create_permission(cartella_condominio.folder_id,Google::Apis::DriveV3::Permission.new(email_address: utente.email,role: "writer",type: "user"),send_notification_email: true)
      end
      Condomino.where(condominio_id: condominio_id,user_id: user_id).update(permission_id: permesso_condominio.id)
    elsif evento == "cedi"
      condomino = Condomino.find_by(condominio_id: condominio_id, user_id: user_id)
      begin 
        @service.delete_permission(cartella_condominio.folder_id, condomino.permission_id)
        condomino.update(permission_id: nil)
      rescue => e
        return false
      end
      if !GdriveUserItem.where(condomino_id: condomino.id,gdrive_condo_items_id: cartella_condominio.id).exists?
        create(utente.uname,utente.email,condomino)
      end
    else 
      nuovo_utente = User.find_by(id: nuovo_user_id)
      condomino = Condomino.find_by(condominio_id: condominio_id, user_id: user_id)
      begin 
        if utente.email.sub(/.+@([^.]+).+/, '\1') == "gmail" && utente.email.sub(/.+@([^.]+).([^.]+).+/, '\2') == "com"
          permesso_condominio = @service.create_permission(cartella_condominio.folder_id,Google::Apis::DriveV3::Permission.new(email_address: nuovo_utente.email,role: "writer",type: "user"),send_notification_email: false)
        else 
          permesso_condominio = @service.create_permission(cartella_condominio.folder_id,Google::Apis::DriveV3::Permission.new(email_address: nuovo_utente.email,role: "writer",type: "user"),send_notification_email: true)
        end
        Condomino.where(condominio_id: condominio_id,user_id: nuovo_utente).update(permission_id: permesso_condominio.id)
        @service.delete_permission(cartella_condominio.folder_id, condomino.permission_id)
        condomino.update(permission_id: nil)
      rescue => e
        return false
      end
      if !GdriveUserItem.where(condomino_id: condomino.id,gdrive_condo_items_id: cartella_condominio.id).exists?
        create(utente.uname,utente.email,condomino)
      end
    end
  end
  

  # DELETE /gdrive_user_items/1 or /gdrive_user_items/1.json
  def destroy(condomino_id,gdrive_condo_items_id)
    @gdrive_user_item = GdriveUserItem.find_by(condomino_id: condomino_id,gdrive_condo_items_id: gdrive_condo_items_id)
    @service = initialize_drive

    begin 
      @service.delete_file(@gdrive_user_item.folder_id)
    rescue => e
      return false
    end
    @gdrive_user_item.destroy
  end
end
