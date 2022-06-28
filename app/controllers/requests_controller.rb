class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[ show destroy edit ]

  # GET /requests or /requests.json
  def index
    @requests = Request.all
  end

  # GET /requests/1 or /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
    @condomino=Condomino.new()
    @condomino.condominio_id = @request.condominio_id
    @condomino.user_id = @request.user_id 
    @condomino.is_condo_admin = false
    if @condomino.save 
      redirect_to condominio_url(@request.condominio_id), notice: "tabella condomino aggiornata"
      @request.destroy
    end
  end

  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)
    @request.user_id = current_user.id
    respond_to do |format|
      if @request.save
        format.html { redirect_to request_url(@request), notice: "Richiesta mandata con successo." }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { redirect_to '/enter', notice: "Errore nella richiesta." }
          format.json {  render :show, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to request_url(@request), notice: "Request was successfully updated." }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url, notice: "Richiesta è stata cancellata." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:condominio_id)
    end
end
