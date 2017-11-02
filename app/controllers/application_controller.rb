require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  protect_from_forgery with: :exception
  before_action :gon_user, unless: :devise_controller?
  before_action :redirect_to_confirm, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  private

  def redirect_to_confirm
    return if action_name == 'email_confirmation'

    redirect_to(email_confirmation_path) if current_user && !current_user&.email_verified?
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :forbidden }
      format.js   { render json: exception.message, status: :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end
end
