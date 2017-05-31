$(document).on 'ready turbolinks:load', ->
  successful = '3px solid #486d94'
  failed = '2px solid #dc143c'
  normal = '1px solid #808080'
  past_perf1 = '.past-performance1'
  past_perf2 = '.past-performance2'
  past_perf3 = '.past-performance3'
  past_perf4 = '.past-performance4'

  past_performance_validate = (past_peformance, next, one_before, box_border) ->
    URL_REGEX = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
    box_border_style = box_border || failed
    url = $(past_peformance).val()
    unique_url = $(one_before).val()


    if url.match URL_REGEX
      $(past_peformance).css('border-bottom', successful)
      $(next).attr('disabled', false)
      if url == unique_url
        $(past_peformance).val('')
        $(past_peformance).css('border-bottom', box_border_style)
        return false
    else
      $(past_peformance).css('border-bottom', box_border_style)
      $(next).attr('disabled', true)

  present_url = (past_peformance) ->
    $(past_peformance).css('border-bottom', successful)
    $(past_peformance).attr('disabled', false)

  next_input_true = (next_peformance) ->
    $(next_peformance).css 'display', 'block'
    $(next_peformance).attr('disabled', false)



  if $(past_perf1).val()
    $(past_perf1).css('border-bottom', successful)
    $(past_perf2).attr('disabled', false)
  else
    $(past_perf1).keyup ->
      past_performance_validate past_perf1, past_perf2

  if $(past_perf2).val()
    present_url past_perf2
    next_input_true past_perf3
  else
    $(past_perf2).keyup ->
      past_performance_validate past_perf2, past_perf3, past_perf1
      if $(this).val()
        $(past_perf3).css 'display', 'block'
      else
        $(past_perf3).css 'display', 'none'

  if $(past_perf3).val()
    present_url past_perf3
    next_input_true past_perf4
  else
    $(past_perf3).keyup ->
      past_performance_validate past_perf3, past_perf4, '', normal
      if $(this).val() == $(past_perf1).val() || $(this).val() == $(past_perf2).val()
        $(this).val('')
        $(this).css('border-bottom', normal)

      if $(this).val()
        $(past_perf4).css 'display', 'block'
      else
        $(past_perf4).css 'display', 'none'

  if $(past_perf4).val()
    present_url past_perf4
  else
    $(past_perf4).keyup ->
      past_performance_validate past_perf4, '', '', normal

      if $(this).val() == $(past_perf1).val() || $(this).val() == $(past_perf2).val() || $(this).val() == $(past_perf3).val()
        $(this).val('')
        $(this).css('border-bottom', normal)
