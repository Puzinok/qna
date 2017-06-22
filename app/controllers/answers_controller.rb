class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer, notice: 'Your answer succefully created.'
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user == @answer.user
      @answer.destroy
      redirect_to @answer.question
    else
      redirect_to @answer.question
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user: current_user)
  end
end
