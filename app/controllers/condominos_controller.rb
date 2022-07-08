class CondominosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_condomino, only: %i[ show edit update destroy ]

  # GET /condominos or /condominos.json
  def index
    @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
    @condomini = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: false)
    @condomini_amm = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: true)
    authorize! :index, Condomino
  end

  def eleva_condomino
    authorize! :destroy, Condominio
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

  def cedi_ruolo_leader
    authorize! :destroy, Condominio
    respond_to do |format|
      if params.has_key?(:condominio_id) && params.has_key?(:old_amministratore_id) && params.has_key?(:new_amministratore_id)
        @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
        if Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:old_amministratore_id]).update(is_condo_admin: false) && Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:new_amministratore_id]).update(is_condo_admin: true)
          format.html { redirect_to condominio_condominos_path(@condominio_attuale), notice: User.find_by(id: params[:new_amministratore_id]).uname + ' è il nuovo amministratore del condominio.' }
          format.json { render :show, status: :ok, location: @condominio_attuale }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @condominio_attuale.errors, status: :unprocessable_entity }
        end
      else 
        @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
        if Condomino.find_by(condominio_id: params[:condominio_id],user_id: params[:old_amministratore_id]).update(is_condo_admin: false)
          format.html { redirect_to condominio_condominos_path(@condominio_attuale), notice: User.find_by(id: params[:old_amministratore_id]).uname + ' non è più un amministratore del condominio.' }
          format.json { render :show, status: :ok, location: @condominio_attuale }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @condominio_attuale.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def choose_new_leader
    authorize! :destroy, Condominio
    if params.has_key?(:condominio_id) && params.has_key?(:old_amministratore_id)
      @condominio_attuale = Condominio.find_by(id: params[:condominio_id])
      @condomini = Condomino.where(condominio_id: params[:condominio_id], is_condo_admin: false)
      @condominio_amministratore = params[:old_amministratore_id]
    else
      redirect_to root_path, :alert => "Parametri errati"
    end
  end

  # GET /condominos/1 or /condominos/1.json
  #def show
  #end

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
    authorize! :destroy, Condominio
    @condomino = Condomino.find(params[:id])
    @condominio = Condominio.find_by(id: @condomino.condominio_id)
    @condomino.destroy

    respond_to do |format|
      format.html { redirect_to condominio_condominos_path(@condominio), notice: "Membro espulso correttamente." }
      format.json { head :no_content }
    end
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
