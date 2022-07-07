class CondominosController < ApplicationController
  before_action :authenticate_user!
# before_action :set_request, only: %i[create destroy]

  def index
    @condomini = Condomino.where(condomino_id: params[:condomino_id])
    @condomini_amm = Condomino.where(condomino_id: params[:condomino_id], is_condo_admin: true)
    authorize! :index, Condomino
  end

  def show
  end

  def new
    @condomino = Condomino.new
  end

  def create
    authorize! :create, Condominio
    @condomino = Condomino.new(condomino_params)
    @condomino.save!
  end
  
  def destroy
    @condomino = Condomino.find(params[:id])
    @condomino.destroy
    redirect_to root_path()
  end

  private
    def set_condomino
      @condomino = Condomino.find(params[:id])
    end

    def condomino_params
      params.require(:condomino).permit(:condomino_id, :user_id)
    end
end
