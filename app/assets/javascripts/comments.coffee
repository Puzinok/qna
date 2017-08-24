
renderComment = ->
 App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      question_id = $('#question').data('questionId')
      console.log('Comments connected to question ' + question_id)
      @perform 'follow', question_id: question_id
    ,
    received: (data) ->
      console.log(data)
      $('#question_comments').append(JST["templates/comment"](data))
  })

$(document).on("ready", renderComment)