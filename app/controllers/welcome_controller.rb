class WelcomeController < ApplicationController
  before_action :check_signed_in

  def check_signed_in
    if(current_user != nil && current_user.is_admin?)
      redirect_to '/admin' if signed_in?
    elsif(current_user != nil && Condomino.where(user_id: current_user.id).exists?)
      redirect_to '/condominios' if signed_in?
    else
      redirect_to '/enter' if signed_in?
    end
  end

  def index
  end
end
