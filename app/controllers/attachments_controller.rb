class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end
end
