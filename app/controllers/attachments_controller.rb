class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  def destroy
    @attachment = Attachment.find(params[:id])
    return unless current_user.author_of?(@attachment.attachable)
    @attachment.destroy
    render :destroy
  end

  def attachment_params
    params.require(:attachment).permit(:id)
  end
end
