$ ->
  $('.last-name-form').focus ->
    $('.last-name').css 'display', 'block'

  $('.last-name-form').blur ->
    $('.last-name').css 'display', 'none'

  $('.first-name-form').focus ->
    $('.first-name').css 'display', 'block'

  $('.first-name-form').blur ->
    $('.first-name').css 'display', 'none'

  $('.username-form').focus ->
    $('.username').css 'display', 'block'

  $('.username-form').blur ->
    $('.username').css 'display', 'none'

  $('.email-form').focus ->
    $('.email').css 'display', 'block'

  $('.email-form').blur ->
    $('.email').css 'display', 'none'

  $('.password-form').focus ->
    $('.password').css 'display', 'block'

  $('.password-form').blur ->
    $('.password').css 'display', 'none'

  $('.confirmation-form').focus ->
    $('.confirmation').css 'display', 'block'

  $('.confirmation-form').blur ->
    $('.confirmation').css 'display', 'none'
