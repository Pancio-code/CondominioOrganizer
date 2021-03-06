class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @user = User.da_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        session[:time_login] = Time.now
        data = request.env['omniauth.auth'].credentials
        File.write 'credentials.data', [data['token'], data['refresh_token']].to_json
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
  end
end
