$(document).on 'click', 'a[href^="#"]', (e) ->
  e.preventDefault()
  header_hight = 100
  target = $(this.hash)
  if $(this).attr('href') == '#'
    return
  position = target.offset().top - header_hight
  $("html, body").animate {
    scrollTop: position
  }, 300, "swing"
