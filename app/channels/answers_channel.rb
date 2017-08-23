class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers_question_id_#{data['question_id']}"
  end
end