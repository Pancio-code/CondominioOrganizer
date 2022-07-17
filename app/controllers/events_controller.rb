class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :set_condominio, only: %i[ index new create show edit update destroy ]
  before_action :authenticate_user!
  # GET /events or /events.json
  def index 
    authorize! :index, Event
    @events = Event.where(condominio_id: @condominio.id).order(start_time: :asc)
  end

  # GET /events/1 or /events/1.json
  def show
    authorize! :show, Event
  end

  # GET /events/new
  def new
    authorize! :update, @condominio
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    authorize! :update, @condominio
    @event = Event.new(event_params)
    @event.condominio_id = params[:condominio_id]
    @condomini = Condomino.where(condominio_id: params[:condominio_id])
    @event.categoria = params[:categoria]
    respond_to do |format|
      if @event.save
        if current_user.from_oauth?
          session_time = Time.now - session[:time_login].to_datetime
          list_email = []
          @condomini.each do |condomino|
            utente_corrente_email = User.find(condomino.user_id).email
            list_email << Google::Apis::CalendarV3::EventAttendee.new(email: utente_corrente_email)
          end
          require 'json' 
          token, refresh_token = *JSON.parse(File.read('credentials.data'))
          #client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'calendar')
          client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'calendar')
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
          service = Google::Apis::CalendarV3::CalendarService.new
          service.authorization = client
          if params[:categoria] == "pagamento"
            event = Google::Apis::CalendarV3::Event.new(
              start: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
              end: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
              summary: "Avviso " + params[:categoria],
              location: @condominio.nome + ', ' + @condominio.comune + ', ' + @condominio.indirizzo,
              description: @event.titolo,
              attendees: list_email,
              recurrence: [
                'RRULE:FREQ=WEEKLY'
              ],
              reminders: Google::Apis::CalendarV3::Event::Reminders.new(
                use_default: false,
                overrides: [
                  Google::Apis::CalendarV3::EventReminder.new(
                    reminder_method: 'email',
                    minutes: 10080
                  )
                ]
              )
            )
          else
            event = Google::Apis::CalendarV3::Event.new(
              start: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
              end: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
              summary: "Avviso " + params[:categoria],
              location: @condominio.nome + ', ' + @condominio.comune + ', ' + @condominio.indirizzo,
              description: @event.titolo,
              attendees: list_email,
            )
          end
          calendar = service.get_calendar(:primary)
          result = service.insert_event(calendar.id, event,send_notifications: true)
          if !@event.update(calendar_id: result.id)
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @event.errors, status: :unprocessable_entity }
          end
        else
          @condomini.each do |condomino|
            CondominioMailer.with(email: User.find(condomino.user_id).email ,message: @event.titolo,categoria: params[:categoria]).send_event_invitation(@event.start_time,current_user.id,@condominio.id).deliver_later
          end
        end
        format.html { redirect_to event_url(id: @event.id,condominio_id: @condominio.id), notice: "Evento creato correttamente." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    authorize! :update, @condominio
    @condomini = Condomino.where(condominio_id: params[:condominio_id])
    @event.categoria = params[:categoria]
    respond_to do |format|
      if @event.update(event_params)
        if current_user.from_oauth? && @event.calendar_id != nil
          session_time = Time.now - session[:time_login].to_datetime
          list_email = []
          @condomini.each do |condomino|
            utente_corrente_email = User.find(condomino.user_id).email
            list_email << Google::Apis::CalendarV3::EventAttendee.new(email: utente_corrente_email)
          end
          require 'json' 
          token, refresh_token = *JSON.parse(File.read('credentials.data'))
          #client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'calendar')
          client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'calendar')
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
          service = Google::Apis::CalendarV3::CalendarService.new
          service.authorization = client
          
          calendar = service.get_calendar(:primary)
          begin
            service.get_event(calendar.id, @event.calendar_id)

            if params[:categoria] == "pagamento"
              event = Google::Apis::CalendarV3::Event.new(
                start: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
                end: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
                summary: "Avviso " + params[:categoria],
                location: @condominio.nome + ', ' + @condominio.comune + ', ' + @condominio.indirizzo,
                description: @event.titolo,
                attendees: list_email,
                recurrence: [
                  'RRULE:FREQ=WEEKLY'
                ],
                reminders: Google::Apis::CalendarV3::Event::Reminders.new(
                  use_default: false,
                  overrides: [
                    Google::Apis::CalendarV3::EventReminder.new(
                      reminder_method: 'email',
                      minutes: 10080
                    )
                  ]
                )
              )
            else
              event = Google::Apis::CalendarV3::Event.new(
                start: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
                end: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339,time_zone: "Europe/Rome"),
                summary: "Avviso " + params[:categoria],
                location: @condominio.nome + ', ' + @condominio.comune + ', ' + @condominio.indirizzo,
                description: @event.titolo,
                attendees: list_email,
              )
            end
            service.update_event(calendar.id, @event.calendar_id, event,send_notifications: true)
          rescue => e
            if !e.status_code == 404
              redirect_to root_path, :alert => e.message
              return false
            end
          end
        else
          @condomini.each do |condomino|
            CondominioMailer.with(email: User.find(condomino.user_id).email ,message: @event.titolo,categoria: params[:categoria]).send_event_invitation(@event.start_time,current_user.id,@condominio.id).deliver_later
          end
        end
        format.html { redirect_to event_url(id: @event.id,condominio_id: @condominio.id), notice: "Evento modificato correttamente." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    authorize! :update, @condominio
    if @event.calendar_id != nil
      if current_user.from_oauth?
        session_time = Time.now - session[:time_login].to_datetime
        require 'json' 
        token, refresh_token = *JSON.parse(File.read('credentials.data'))
        #client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'calendar')
        client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'calendar')
        if client.expired? || (session_time/60).to_i > 28  
          session[:time_login] = Time.now
          abort (session_time.to_i).inspect         
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
        service = Google::Apis::CalendarV3::CalendarService.new
        service.authorization = client
        
        calendar = service.get_calendar(:primary)
        begin
          service.get_event(calendar.id, @event.calendar_id)
          service.delete_event(calendar.id, @event.calendar_id,send_notifications: true)
        rescue => e
          if !e.status_code == 404
            redirect_to root_path, :alert => e.message
            return false
          end
        end
      end
    end

    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url(condominio_id: @condominio.id), notice: "Evento eliminato correttamente." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_condominio
      @condominio = Condominio.find(params[:condominio_id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:categoria,:titolo, :start_time,:condominio_id)
    end
end
