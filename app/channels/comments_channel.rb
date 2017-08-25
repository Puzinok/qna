class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_commentable_id_#{data['question_id']}"
  end
end
