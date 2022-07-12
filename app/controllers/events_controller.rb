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
    authorize! :new, Event
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    authorize! :create, Event
    @event = Event.new(event_params)
    @event.condominio_id = params[:condominio_id]
    @condomini = Condomino.where(condominio_id: params[:condominio_id])
    @event.categoria = params[:categoria]
    respond_to do |format|
      if @event.save
        if current_user.from_oauth?
          require 'json' 
          token, refresh_token = *JSON.parse(File.read('credentials.data'))
          client = Signet::OAuth2::Client.new(client_id: Figaro.env.google_api_id,client_secret: Figaro.env.google_api_secret,access_token: token,refresh_token: refresh_token,token_credential_uri: 'https://accounts.google.com/o/oauth2/token',scope: 'calendar')
          if client.expired?
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
              attendees: [Google::Apis::CalendarV3::EventAttendee.new(email: "andrea.pancio00@gmail.com")],
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
              start: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339),
              end: Google::Apis::CalendarV3::EventDateTime.new(date_time: @event.start_time.to_datetime.rfc3339),
              summary: "Avviso " + params[:categoria],
              location: @condominio.nome + ', ' + @condominio.comune + ', ' + @condominio.indirizzo,
              description: @event.titolo,
              attendees: [Google::Apis::CalendarV3::EventAttendee.new(email: "andrea.pancio00@gmail.com")],
            )
          end
          calendar = service.get_calendar(:primary)
          service.insert_event(calendar.id, event,send_notifications: true)
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
    authorize! :update, Event
    @condomini = Condomino.where(condominio_id: params[:condominio_id])
    @event.categoria = params[:categoria]
    respond_to do |format|
      if @event.update(event_params)
        @condomini.each do |condomino|
          CondominioMailer.with(email: User.find(condomino.user_id).email ,message: @event.titolo,categoria: params[:categoria]).send_event_invitation(@event.start_time,current_user.id,@condominio.id).deliver_later
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
    authorize! :destroy, Event
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
