class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update, :choose_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user&.author_of?(@answer)
  end

  def update
    @answers = Answer.all
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def choose_best
    @answer = Answer.find(params[:answer_id])
    @question = @answer.question
    @answers = Answer.all

    @answer.toggle_best! if current_user&.author_of?(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
