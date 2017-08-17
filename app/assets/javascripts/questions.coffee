# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question').show();

  $('.vote_for_question, .vote_against_question, .vote_reset_question').bind 'ajax:success', (e, data, status, xhr) ->
    rating_data = $.parseJSON(xhr.responseText)
    $('#question .rating_sum').text(rating_data.rating)
    $('#question .rating_msg').text(rating_data.message)

  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $('#question .rating_msg').text(errors.message)

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      console.log data
      $('#questions_list .list-group').append(JST["templates/question_item"](data))
  })

$(document).ready(ready)
$(document).on('turbolinks', ready)
#$(document).on('page:update', ready)