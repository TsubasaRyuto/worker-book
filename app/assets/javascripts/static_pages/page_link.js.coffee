$(document).on 'click', 'a[href^="#"]', (e) ->
  e.preventDefault()
  header_hight = 100
  target = $(this.hash)
  position = target.offset().top - header_hight
  console.log position
  $("html, body").animate {
    scrollTop: position
  }, 300, "swing"
