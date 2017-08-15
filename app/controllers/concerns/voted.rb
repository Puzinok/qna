module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_for, :vote_against, :vote_reset]
  end

  def vote_for
    vote(1)
  end

  def vote_against
    vote(-1)
  end

  def vote_reset
    if @votable.vote_destroy(current_user)
      render_rating(@votable, 'Your vote has been canceled.')
    else
      render_msg(@votable, 'Your not voted!', 422)
    end
  end

  private

  def vote(value)
    if @votable.vote(current_user, value)
      render_rating(@votable)
    else
      render_msg(@votable, 'User can vote once!', 422)
    end
  end

  def render_rating(item, message = 'You voted!')
    render json: { id: item.id, rating: item.rating, message: message }
  end

  def render_msg(item, message, status)
    render json: { id: item.id, message: message }, status: status
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
