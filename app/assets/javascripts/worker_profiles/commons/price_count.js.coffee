$(document).on 'turbolinks:load', ->
  price_count = ->
    COMMISSION = 0.05
    WORKING_DAYS = 22
    input_price = $('#input-price').val()
    input_price = parseInt(input_price)
    service_charge = document.getElementById('service-charge')
    receive_day = document.getElementById('receive-day')
    receive_month = document.getElementById('receive-month')

    if !input_price || input_price < 30000
      service_charge.innerHTML = '0'
      receive_day.innerHTML = '0'
      receive_month.innerHTML = '0'
      return false

    if input_price && input_price >= 30000
      service_charge_count = parseInt input_price * COMMISSION
      service_charge.innerHTML = [service_charge_count].toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')

      receive_day_count = parseInt input_price - service_charge_count
      receive_day.innerHTML = [receive_day_count].toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')

      receive_month_count = parseInt receive_day_count * WORKING_DAYS
      receive_month.innerHTML = [receive_month_count].toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')

      input_price = [input_price].toString()
      $('#input-price').val(input_price)
      return true

  $('#input-price').keyup ->
    price_count()
