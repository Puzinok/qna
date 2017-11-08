class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    respond_with Question.find(params[:question_id]).answers
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with @question.answers.create(answer_params.merge(user_id: current_resource_owner.id))
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
