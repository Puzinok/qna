class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def facebook
    sign_in_with('Facebook')
  end

  def twitter
    sign_in_with("Twitter")
  end

  private

  def sign_in_with(provider)
    user = User.find_for_oauth(request.env['omniauth.auth'])
    if user.email_verified?
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      sign_in user
      redirect_to email_confirmation_path(user)
    end
  end
end
