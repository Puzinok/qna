class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, except: [:index, :new, :create]
  before_action :build_answer, only: [:show]

  after_action :publish_question, only: [:create]

  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def show
    gon.question_user_id = @question.user.id
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy) if current_user&.author_of?(@question)
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
                                 id: @question.id, title: @question.title)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = Answer.new
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
