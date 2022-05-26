class SessionsController < ApplicationController

    def create
      @user = User.find_by(username: params[:username])
      
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user_id
        redirect_to user_path
      else
            message = "Errore"
            redirect_to login_path, notice:message
      end
    end
end