class CondominiosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_condominio, only: %i[ show edit update destroy ]

  # GET /condominios or /condominios.json
  def index
    @condominios = Condominio.all
    @condomini_amministrati = Condominio.where("EXISTS(SELECT 1 from condominos where condominos.condominio_id = condominios.id AND condominos.user_id = (?) AND condominos.is_condo_admin = true) ",current_user.id)
    @condomini_partecipante = Condominio.where("EXISTS(SELECT 1 from condominos where condominos.condominio_id = condominios.id AND condominos.user_id = (?) AND condominos.is_condo_admin = false) ",current_user.id)
  end

  # GET /condominios/1 or /condominios/1.json
  def show
    @condominio_ids = Condominio.find(params[:id])
    authorize! :show, @condominio_ids
  end

  # GET /condominios/new
  def new
    @condominio = Condominio.new
  end

  # GET /condominios/1/edit
  def edit
  end

  # POST /condominios or /condominios.json
  def create
    @condominio = Condominio.new(condominio_params)
#    @condominio.condominos_attributes = [{ condominio_id: params[:id], user_id: current_user.id, is_condo_admin: true }]
    

    respond_to do |format|
      if @condominio.save!
      	@condomino = Condomino.new(condominio_id: @condominio.id, user_id: current_user.id, is_condo_admin: true)
      	@condomino.save
        format.html { redirect_to condominio_url(@condominio), notice: "Condominio was successfully created." }
        format.json { render :show, status: :created, location: @condominio }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @condominio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /condominios/1 or /condominios/1.json
  def update
    respond_to do |format|
      if @condominio.update(condominio_params)
        format.html { redirect_to condominio_url(@condominio), notice: "Condominio was successfully updated." }
        format.json { render :show, status: :ok, location: @condominio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @condominio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /condominios/1 or /condominios/1.json
  def destroy
    @condominio_id = @condominio.id
    @condominio.destroy

    respond_to do |format|
      Condomino.where(condominio_id: @condominio_id).destroy_all
      format.html { redirect_to condominios_url, notice: "Condominio was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_condominio
      @condominio = Condominio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def condominio_params
      params.require(:condominio).permit(:nome, :comune, :indirizzo, :latitudine, :longitudine, :flat_code,:avatar)
    end
end
