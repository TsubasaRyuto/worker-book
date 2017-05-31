# CoffeeScriptでURLからパラメーターを取得。もっといい方法があれば修正する
url = window.location.href
receiver = url.split('/')[5].slice(1)

App.chat = App.cable.subscriptions.create { channel: "ChatChannel", partner_username: receiver },
  connected: ->

  disconnected: ->

  received: (data) ->
    $('#messages').append data['message']

  speak: (message) ->
    @perform 'speak', { message: message }

$(document).on 'ready turbolinks:load', ->
  $('#send-message').click ->
    return false if $('#message-input').val() == ''
    App.chat.speak $('#message-input').val()
    $('#message-input').val('')
    $('.messages-body').animate({scrollTop: $('.messages-body')[0].scrollHeight}, 'fast');
