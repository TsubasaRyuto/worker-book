$(document).on 'turbolinks:load', ->
  $('#message-input').autosize();
  $('.messages-body').animate({scrollTop: $('.messages-body')[0].scrollHeight}, 'swing');
