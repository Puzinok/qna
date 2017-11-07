class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    respond_with Question.all
  end

  def show
    respond_with @question
  end
end
