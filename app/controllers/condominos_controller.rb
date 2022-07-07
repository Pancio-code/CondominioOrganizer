class CondominosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_condomino, only: %i[ show edit update destroy ]

  # GET /condominos or /condominos.json
  def index
    @condomini = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: false)
    @condomini_amm = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: true)
    authorize! :index, Condomino
  end

  def eleva_condomino
    respond_to do |format|
      if Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:user_id]).update(is_condo_admin: true)
        format.html { redirect_to condominio_condominos_path(Condominio.find_by(id: params[:condominio_id])), notice: User.find_by(id: params[:user_id]).uname + ' è diventato un amministratore del condominio.' }
        format.json { render :show, status: :ok, location: @condominio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @condomino.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /condominos/1 or /condominos/1.json
  def show
  end

  # GET /condominos/new
  def new
    @condomino = Condomino.new
  end

  # GET /condominos/1/edit
  def edit
  end

  # POST /condominos or /condominos.json
  def create
    authorize! :create, Condominio
    @condomino = Condomino.new(condomino_params)
    @condomino.save!
  end

  # PATCH/PUT /condominos/1 or /condominos/1.json
  def update
    respond_to do |format|
      if @condomino.update(condomino_params)
        format.html { redirect_to condomino_url(@condomino), notice: "Condomino was successfully updated." }
        format.json { render :show, status: :ok, location: @condomino }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @condomino.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /condominos/1 or /condominos/1.json
  def destroy
    authorize! :destroy, Condomino
    @condomino = Condomino.find(params[:id])
    @condomino.destroy
    redirect_to root_path()
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_condomino
      @condomino = Condomino.find(params[:id])
    end

    def condomino_params
      params.require(:condomino).permit(:condomino_id, :user_id)
    end
end
