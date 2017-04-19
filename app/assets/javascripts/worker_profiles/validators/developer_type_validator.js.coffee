$(document).on 'turbolinks:load', ->
  $('.dev-type-check:checkbox').change ->
    count = $('.dev-type-check:checked').length
    $not = $('.dev-type-check:checkbox').not(':checked')
    if count >= 4
      $not.attr('disabled', true)
    else
      $not.attr("disabled", false)

    if count == 4
      $('.warning').css 'color', '#dc143c'
    else
      $('.warning').css 'color', '#808080'
