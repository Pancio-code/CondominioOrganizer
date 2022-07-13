class GdriveCondoItemsController < ApplicationController
  before_action :set_gdrive_condo_item, only: %i[ show edit update destroy ]

  # GET /gdrive_condo_items or /gdrive_condo_items.json
  def index
    @gdrive_condo_items = GdriveCondoItem.all
  end

  # GET /gdrive_condo_items/1 or /gdrive_condo_items/1.json
  def show
  end

  # GET /gdrive_condo_items/new
  def new
    @gdrive_condo_item = GdriveCondoItem.new
  end

  # GET /gdrive_condo_items/1/edit
  def edit
  end

  # POST /gdrive_condo_items or /gdrive_condo_items.json
  def create
    @gdrive_condo_item = GdriveCondoItem.new(gdrive_condo_item_params)

    respond_to do |format|
      if @gdrive_condo_item.save
        format.html { redirect_to gdrive_condo_item_url(@gdrive_condo_item), notice: "Gdrive condo item was successfully created." }
        format.json { render :show, status: :created, location: @gdrive_condo_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gdrive_condo_item.errors, status: :unprocessable_entity }
      end
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

  # DELETE /gdrive_condo_items/1 or /gdrive_condo_items/1.json
  def destroy
    @gdrive_condo_item.destroy

    respond_to do |format|
      format.html { redirect_to gdrive_condo_items_url, notice: "Gdrive condo item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gdrive_condo_item
      @gdrive_condo_item = GdriveCondoItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gdrive_condo_item_params
      params.require(:gdrive_condo_item).permit(:folder_id, :condominio_id)
    end
end
