class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check

  def index
    respond_with Question.all
  end
end
