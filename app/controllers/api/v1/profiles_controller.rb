class Api::V1::ProfilesController < Api::V1::BaseController
  skip_authorization_check

  def me
    respond_with current_resource_owner
  end

  def users
    respond_with User.where.not(id: current_resource_owner.id)
  end
end
