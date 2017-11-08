class Api::V1::ProfilesController < Api::V1::BaseController
  skip_load_and_authorize_resource
  before_action { authorize! :read, current_resource_owner }

  def me
    respond_with current_resource_owner
  end

  def users
    respond_with User.where.not(id: current_resource_owner.id)
  end
end
