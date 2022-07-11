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
    respond_to do |format|
      if @event.save
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
    respond_to do |format|
      if @event.update(event_params)
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
      params.require(:event).permit(:titolo, :start_time,:condominio_id)
    end
end
