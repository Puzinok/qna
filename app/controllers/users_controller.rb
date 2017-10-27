class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_confirmed

  skip_authorization_check

  def email_confirmation
    if request.patch? && params[:user]
      if current_user.update(user_params)
        redirect_to questions_path, notice: 'Please check your email, and confirm binding your profile to twitter.'
      end
    end
  end

  private

  def redirect_if_confirmed
    redirect_to root_path if current_user.email_verified?
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
