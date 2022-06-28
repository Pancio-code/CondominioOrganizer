class CondominoController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i [create]

  def new
    @condomino = Condomino.new
  end

  def create
    @condomino = Condomino.new(condomino_params)
    @condomino.save!
  end

  private
    def set_condomino
      @condomino = Condomino.find(params[:id])
    end

    def condomino_params
      params.require(:condomino).permit(:condomino_id, :user_id)
    end
end
