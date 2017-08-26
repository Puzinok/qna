# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready', ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('body').on 'click', ('.vote_for_answer, .vote_against_answer, .vote_reset_answer'), (e) ->
    e.preventDefault();
    $('.vote_for_answer, .vote_against_answer, .vote_reset_answer').bind 'ajax:success', (e, data, status, xhr) ->
      rating_data = $.parseJSON(xhr.responseText)
      rating_sum = $('#answer_body_' + rating_data.id + ' .rating_sum')
      rating_msg = $('#answer_body_' + rating_data.id + ' .rating_msg')
      $(rating_sum).text(rating_data.rating)
      $(rating_msg).text(rating_data.message)

    .bind 'ajax:error', (e, xhr, status, error) ->
      errors_data = $.parseJSON(xhr.responseText)
      answer_body = '#answer_body_' + errors_data.id
      $(answer_body + ' .rating_msg').text(errors_data.message)

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      question_id = $('#question').data('questionId')
      console.log('AnswerChannel to question id:' + question_id)
      @perform 'follow', question_id: question_id
    ,
    received: (data) ->
      console.log data
      if gon.user_id != data.answer.user_id
        $('.answers').append(JST["templates/answer"](data))
  })