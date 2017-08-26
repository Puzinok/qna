class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy, :update]

  after_action :publish_answer, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if current_user&.author_of?(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def choose_best
    @answer = Answer.find(params[:answer_id])
    @question = @answer.question
    @answers = @question.answers

    @answer.toggle_best! if current_user&.author_of?(@question)
  end

  private

  def publish_answer
    @question = Question.find(params[:question_id])
    ActionCable.server.broadcast(
      "answers_question_id_#{@question.id}",
      answer: @answer, attachments: @answer.get_attachments
    )
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
