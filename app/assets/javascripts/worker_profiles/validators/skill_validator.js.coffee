$ ->
  $('.ui-autocomplete-input').keyup ->
    count = $('.tagit-hidden-field').length
    console.log('test')
    if count < 5
      $('.tagit').css 'border', '2px solid #dc143c'
      $('.skill-minimum-warning').css 'color', '#dc1432'
    else if count == 10
      $('.skill-max-warning').css 'display', 'block'
    else
      $('.tagit').css 'border', '2px solid #486d94'
      $('.skill-minimum-warning').css 'display', 'none'
