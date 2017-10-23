class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :redirect_if_confirmed

  def email_confirmation
    @user = current_user

    if request.patch? && params[:user]
      if @user.update(user_params)
        redirect_to questions_path, notice: 'Please check your email, and confirm binding your profile to twitter.'
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def redirect_if_confirmed
    redirect_to root_path if @user.email_verified?
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
