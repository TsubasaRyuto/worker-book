$(document).on 'click', '#next-step', ->
  $('html, body').animate({ scrollTop: $('.create-clients').offset().top }, 1000)
  $('.fade-out').hide()
  $('#signup-client-user').show()
