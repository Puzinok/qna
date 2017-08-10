class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, except: [:index, :new, :create]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    @answer = Answer.new
    @answer.attachments.build
  end

  def destroy
    if current_user&.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question succefully deleted.'
    else
      redirect_to questions_path, notice: 'Your question not deleted.'
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def vote_for
    voting(1)
  end

  def vote_against
    voting(-1)
  end

  def vote_reset
    if @vote = @question.voted?(current_user)
      @vote.destroy
      render json: { rating: @question.rating, message: 'Your vote has been canceled.' }
    else
      render json: { message: 'Your not voted!' }
    end
  end

  private

  def voting(value)
    return if current_user.author_of?(@question)
    vote = @question.votes.build
    vote.value = value
    vote.user = current_user

    if vote.save
      render_rating(@question)
    else
      render_errors(vote)
    end
  end

  def render_errors(item)
    render json: item.errors.full_messages, status: :unprocessable_entity
  end

  def render_rating(item)
    render json: { rating: item.rating, message: 'You voted!' }
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
