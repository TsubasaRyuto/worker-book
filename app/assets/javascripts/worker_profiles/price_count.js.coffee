$(document).on 'turbolinks:load', ->
  price_count = ->
    FEE = 10
    WORKING_DAYS = 22
    input_price = $('#input-price').val()
    input_price = parseInt(input_price)
    service_fee = document.getElementById('service-fee')
    receive_day = document.getElementById('receive-day')
    receive_month = document.getElementById('receive-month')

    if !input_price || input_price < 30000
      service_fee.innerHTML = '0'
      receive_day.innerHTML = '0'
      receive_month.innerHTML = '0'
      return false

    if input_price && input_price >= 30000
      service_fee_count = parseInt input_price / FEE
      service_fee.innerHTML = [service_fee_count].toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')

      receive_day_count = parseInt input_price - service_fee_count
      receive_day.innerHTML = [receive_day_count].toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')

      receive_month_count = parseInt receive_day_count * WORKING_DAYS
      receive_month.innerHTML = [receive_month_count].toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')

      input_price = [input_price].toString()
      $('#input-price').val(input_price)
      return true

  $('#input-price').keyup ->
    price_count()
