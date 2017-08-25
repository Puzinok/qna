$(document).on 'ready', ->
 App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      questionId = $('#question').data('questionId')
      console.log('Comments connected to question ' + questionId)
      @perform 'follow', question_id: questionId
    ,
    received: (data) ->
      if data.comment.commentable_type == 'Question'
        $('#question_comments').append(JST["templates/comment"](data))
      else
        answerDiv = $('#answer_body_' + data.comment.commentable_id + ' #answer_comments')
        (answerDiv).append(JST["templates/comment"](data))
  })