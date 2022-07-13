class GdrivesController < ApplicationController
  before_action :set_gdrife, only: %i[ show edit update destroy ]

  # GET /gdrives or /gdrives.json
  def index
    @gdrives = Gdrive.all
  end

  # GET /gdrives/1 or /gdrives/1.json
  def show
  end

  # GET /gdrives/new
  def new
    @gdrife = Gdrive.new
  end

  # GET /gdrives/1/edit
  def edit
  end

  # POST /gdrives or /gdrives.json
  def create
    @gdrife = Gdrive.new(gdrife_params)

    respond_to do |format|
      if @gdrife.save
        format.html { redirect_to gdrife_url(@gdrife), notice: "Gdrive was successfully created." }
        format.json { render :show, status: :created, location: @gdrife }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gdrife.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gdrives/1 or /gdrives/1.json
  def update
    respond_to do |format|
      if @gdrife.update(gdrife_params)
        format.html { redirect_to gdrife_url(@gdrife), notice: "Gdrive was successfully updated." }
        format.json { render :show, status: :ok, location: @gdrife }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gdrife.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gdrives/1 or /gdrives/1.json
  def destroy
    @gdrife.destroy

    respond_to do |format|
      format.html { redirect_to gdrives_url, notice: "Gdrive was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gdrife
      @gdrife = Gdrive.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gdrife_params
      params.require(:gdrife).permit(:condo_cartella_id, :cartella_id, :condomino_id)
    end
end
