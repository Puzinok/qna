class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user&.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer succefully deleted.'
    else
      redirect_to @answer.question, notice: 'Your answer not deleted.'
    end
  end

  def update
    @answers = Answer.all
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
