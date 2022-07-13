class GdriveUserItemsController < ApplicationController
  before_action :set_gdrive_user_item, only: %i[ show edit update destroy ]

  # GET /gdrive_user_items or /gdrive_user_items.json
  def index
    @gdrive_user_items = GdriveUserItem.all
  end

  # GET /gdrive_user_items/1 or /gdrive_user_items/1.json
  def show
  end

  # GET /gdrive_user_items/new
  def new
    @gdrive_user_item = GdriveUserItem.new
  end

  # GET /gdrive_user_items/1/edit
  def edit
  end

  # POST /gdrive_user_items or /gdrive_user_items.json
  def create
    @gdrive_user_item = GdriveUserItem.new(gdrive_user_item_params)

    respond_to do |format|
      if @gdrive_user_item.save
        format.html { redirect_to gdrive_user_item_url(@gdrive_user_item), notice: "Gdrive user item was successfully created." }
        format.json { render :show, status: :created, location: @gdrive_user_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gdrive_user_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gdrive_user_items/1 or /gdrive_user_items/1.json
  def update
    respond_to do |format|
      if @gdrive_user_item.update(gdrive_user_item_params)
        format.html { redirect_to gdrive_user_item_url(@gdrive_user_item), notice: "Gdrive user item was successfully updated." }
        format.json { render :show, status: :ok, location: @gdrive_user_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gdrive_user_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gdrive_user_items/1 or /gdrive_user_items/1.json
  def destroy
    @gdrive_user_item.destroy

    respond_to do |format|
      format.html { redirect_to gdrive_user_items_url, notice: "Gdrive user item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gdrive_user_item
      @gdrive_user_item = GdriveUserItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gdrive_user_item_params
      params.require(:gdrive_user_item).permit(:folder_id, :condomino_id, :gdrive_condo_items_id)
    end
end
