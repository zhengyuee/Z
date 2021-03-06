class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @auth_data = request.env['omniauth.auth']

    if user_signed_in?
      current_user.sign_in_authentications.where(@auth_data.slice(:provider, :uid)).first_or_create
      redirect_to edit_user_url

    elsif @user = User.find_by(email: @auth_data.info.email)
      @user.sign_in_authentications.where(@auth_data.slice(:provider, :uid)).first_or_create
      flash[:notice] = "You are now logged in with #{@auth_data.provider.titleize}."
      sign_in_and_redirect @user

    else
      @user = User.create_from_omniauth(@auth_data)
      session['devise.omniauth_data'] = @auth_data
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :all
  alias_method :google, :all
end
