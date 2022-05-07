class CondominiosController < ApplicationController
  before_action :set_condominio, only: %i[ show edit update destroy ]

  # GET /condominios or /condominios.json
  def index
    @condominios = Condominio.all
  end

  # GET /condominios/1 or /condominios/1.json
  def show
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

    respond_to do |format|
      if @condominio.save
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
    @condominio.destroy

    respond_to do |format|
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
      params.require(:condominio).permit(:condo_id, :nome_cond, :comune_condo, :coord_condo, :via_condo, :fk_utenti_condo_id_id, :fk_superutenti_condo_id_id)
    end
end
