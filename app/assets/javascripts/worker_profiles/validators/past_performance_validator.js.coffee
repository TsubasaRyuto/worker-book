$ ->
  past_performance_validate = (past_peformance, next, one_before, box_border) ->
    URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
    box_border_style = box_border || '2px solid #dc143c'
    url = $(past_peformance).val()
    unique_url = $(one_before).val()

    if url.match URL_REGEX
      $(past_peformance).css('border-bottom', '3px solid #486d94')
      $(next).attr('disabled', false)
      if url == unique_url
        $(past_peformance).val('')
        $(past_peformance).css('border-bottom', box_border_style)
        return false
    else
      $(past_peformance).css('border-bottom', box_border_style)
      $(next).attr('disabled', true)




  $('.past-performance1').keyup ->
    past_performance_validate '.past-performance1', '.past-performance2'


  $('.past-performance2').keyup ->
    past_performance_validate '.past-performance2', '.past-performance3', '.past-performance1'
    if $(this).val()
      $('.past-performance3').css 'display', 'block'
    else
      $('.past-performance3').css 'display', 'none'

  $('.past-performance3').keyup ->
    past_performance_validate '.past-performance3', '.past-performance4', '', '1px solid #808080'
    if $(this).val() == $('.past-performance1').val() || $(this).val() == $('.past-performance2').val()
      $(this).val('')
      $(this).css('border-bottom', '1px solid #808080')

    if $(this).val()
      $('.past-performance4').css 'display', 'block'
    else
      $('.past-performance4').css 'display', 'none'

  $('.past-performance4').keyup ->
    past_performance_validate '.past-performance4', '', '', '1px solid #808080'
    if $(this).val() == $('.past-performance1').val() || $(this).val() == $('.past-performance2').val() || $(this).val() == $('.past-performance3').val()
      $(this).val('')
      $(this).css('border-bottom', '1px solid #808080')
