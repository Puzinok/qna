alertMessage = (error) ->
  $("<div class='alert alert-danger'>" + error + "<div>").prependTo('#question')

$ ->
  $(document).on "ajax:error", (event, xhr, ajaxOptions, thrownError) ->
    type = xhr.getResponseHeader("content-type")
    return unless type
    if type.search('text/javascript') >= 0
      alertMessage(xhr.responseText)
    else if type.search('application/json') >= 0
      alertMessage($.parseJSON(xhr.responseText)['error'])
    $('html, body').animate({ scrollTop: 0 }, 'middle');
