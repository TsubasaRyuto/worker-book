$(document).on 'ready turbolinks:load', ->
  $('#input-price').keyup ->
    PRICE_REGEX = /^\d+$/
    unit_price = $('#input-price').val()

    if 30000 <= unit_price < 200000 && unit_price.match PRICE_REGEX
      $('#input-price').css 'border-bottom', '3px solid #486d94'
    else
      $('#input-price').css 'border-bottom', '3px solid #dc143c'
