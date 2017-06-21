class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]
  before_action :set_user, only: [:new, :create]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = @user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question succefully created.'
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def destroy
    @question = Question.find(params[:id])
    if current_user == @question.user
      @question.destroy
      redirect_to questions_path
    else
      redirect_to questions_path
    end
  end

  private

  def set_user
    @user = current_user
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
