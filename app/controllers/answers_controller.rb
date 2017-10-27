class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy, :update]
  before_action :set_question, only: [:create, :publish_answer]
  after_action :publish_answer, only: [:create]

  authorize_resource

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def destroy
    respond_with(@answer.destroy) if current_user&.author_of?(@answer)
  end

  def update
    respond_with(@answer.update(answer_params)) if current_user.author_of?(@answer)
  end

  def choose_best
    @answer = Answer.find(params[:answer_id])
    @answers = @answer.question.answers

    @answer.toggle_best! if current_user&.author_of?(@answer.question)
  end

  private

  def publish_answer
    ActionCable.server.broadcast(
      "answers_question_id_#{@question.id}",
      answer: @answer, attachments: @answer.get_attachments
    )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
