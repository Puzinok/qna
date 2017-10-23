class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted? && @user.confirmed?
      sign_in_and_redirect(@user, event: :authentication)
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      sign_in_and_redirect(@user, event: :authentication)
    end
  end
end
