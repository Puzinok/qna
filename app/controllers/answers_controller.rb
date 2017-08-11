class AnswersController < ApplicationController
  before_action :authenticate_user!

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
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def choose_best
    @answer = Answer.find(params[:answer_id])
    @question = @answer.question
    @answers = @question.answers

    @answer.toggle_best! if current_user&.author_of?(@question)
  end

  def vote_for
    voting(1)
  end

  def vote_against
    voting(-1)
  end

  def vote_reset
    answer = Answer.find(params[:id])
    if vote = answer.voted?(current_user)
      vote.destroy
      render json: { id: answer.id, rating: answer.rating, message: 'Your vote has been canceled.' }
    else
      render json: { id: answer.id, message: 'Your not voted!' }, status: :unprocessable_entity
    end
  end

  private

  def voting(value)
    answer = Answer.find(params[:id])
    return if current_user.author_of?(answer)
    vote = answer.votes.build
    vote.value = value
    vote.user = current_user

    if vote.save
      render_rating(answer)
    else
      render_errors(vote)
    end
  end

  def render_errors(item)
    render json: { id: item.votable.id, message: item.errors.full_messages }, status: :unprocessable_entity
  end

  def render_rating(item)
    render json: { id: item.id, rating: item.rating, message: 'You voted!' }
  end


  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
