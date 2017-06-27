class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question succefully created.'
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
  end

  def destroy
    @question = Question.find(params[:id])
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question succefully deleted.'
    else
      render :index
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
