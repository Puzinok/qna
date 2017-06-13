class AnswersController < ApplicationController
  def new
    @question = Question.find(params[:question_id])    
    @answer = @question.answers.new
  end
end
