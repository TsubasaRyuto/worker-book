$(document).on 'ready turbolinks:load', ->
  url = window.location.href
  receiver = url.split('/')[5].slice(1)
  if $('.body').css('display') == 'none' && receiver != 'workerbook'
    $('#chat-body').show()
    $('#chat-side').hide()

  $('#message-input').autosize();
  $('.messages-body').animate({scrollTop: $('.messages-body')[0].scrollHeight}, 'swing');
