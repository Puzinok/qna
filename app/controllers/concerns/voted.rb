module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_for, :vote_against, :vote_reset, :voting]
  end

  def vote_for
    voting(1)
  end

  def vote_against
    voting(-1)
  end

  def vote_reset
    if @vote = @votable.voted?(current_user)
      @vote.destroy
      render json: { id: @votable.id, rating: @votable.rating, message: 'Your vote has been canceled.' }
    else
      render json: { id: @votable.id, message: 'Your not voted!' }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def voting(value)
    return if current_user.author_of?(@votable)
    vote = @votable.votes.build
    vote.value = value
    vote.user = current_user

    if vote.save
      render_rating(@votable)
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
end
