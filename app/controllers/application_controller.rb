class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?

	protected
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:uname, :email, :password,:password_confirmation)}
		devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:avatar, :email, :password,:password_confirmation, :user_change_password, :current_password)}
	 end

	 rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_path, :alert => exception.message
	end
end
