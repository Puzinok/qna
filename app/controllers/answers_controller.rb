class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer succefully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user&.author_of?(@answer)
    redirect_to @answer.question, notice: 'Your answer succefully deleted.'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
