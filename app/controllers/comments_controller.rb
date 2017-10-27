class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  after_action :publish_comment

  authorize_resource

  respond_to :json

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  private

  def publish_comment
    commentable_id = if @commentable.is_a? Question
                       @commentable.id
                     else
                       @commentable.question.id
                     end

    return if @comment.errors.any?
    ActionCable.server.broadcast("comments_commentable_id_#{commentable_id}", comment: @comment)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = Regexp.last_match(1).classify.constantize.find(value)
      end
    end
  end
end
