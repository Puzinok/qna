# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  best_answer = $('#marked_best').parent();
  $(best_answer).prependTo('.answers');

  $('.vote_for_answer, .vote_against_answer, .vote_reset_answer').bind 'ajax:success', (e, data, status, xhr) ->
    rating_data = $.parseJSON(xhr.responseText)
    rating_sum = $('#answer_body_' + rating_data.id + ' .rating_sum')
    rating_msg = $('#answer_body_' + rating_data.id + ' .rating_msg')
    $(rating_sum).text(rating_data.rating)
    $(rating_msg).text(rating_data.message)

  .bind 'ajax:error', (e, xhr, status, error) ->
    errors_data = $.parseJSON(xhr.responseText)
    answer_body = '#answer_body_' + errors_data.id
    $.each errors_data, (index, value) ->
      $(answer_body + ' .rating_msg').text(value)


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)