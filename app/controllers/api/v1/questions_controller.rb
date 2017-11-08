class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    respond_with Question.all
  end

  def show
    respond_with @question
  end

  def create
    respond_with current_resource_owner.questions.create(question_params)
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
