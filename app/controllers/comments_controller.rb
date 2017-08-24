class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment

  def create
    @question = Question.find(params[:question_id])
    @comment = @question.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    return unless current_user
    @question = Question.find(params[:question_id])
    ActionCable.server.broadcast("comments_question_id_#{@question.id}", { comment: @comment } )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end