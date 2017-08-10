# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question').show();

  $('.vote_for, .vote_against').bind 'ajax:success', (e, data, status, xhr) ->
    rating_data = $.parseJSON(xhr.responseText)
    $('#rating_sum').text(rating_data.rating)
    $('#rating_msg').text(rating_data.message)

  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('#rating_msg').text(value)

  $('.vote_reset').bind 'ajax:success', (e, data, status, xhr) ->
    reset_data = $.parseJSON(xhr.responseText)
    $('#rating_sum').text(reset_data.rating)
    $('#rating_msg').text(reset_data.message)



$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)