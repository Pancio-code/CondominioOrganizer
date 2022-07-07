class CondominosController < ApplicationController
  before_action :authenticate_user!
#  before_action :set_request, only: %i[create destroy]

  def new
    @condomino = Condomino.new
  end

  def create
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
