$(document).on 'turbolinks:load', ->
  successful = '3px solid #486d94'
  normal = '1px solid #808080'
  emp_hist1 = '.employment-history1'
  emp_hist2 = '.employment-history2'
  emp_hist3 = '.employment-history3'
  emp_hist4 = '.employment-history4'

  employment_history_validate = (emp_hist, next) ->
    company_name = $(emp_hist).val()
    if company_name.length > 2
      $(emp_hist).css('border-bottom', successful)
      $(next).attr('disabled', false)
    else
      $(emp_hist).css('border-bottom', normal)
      $(next).attr('disabled', true)

  present_emp = (emp_hist) ->
    $(emp_hist).css('border-bottom', successful)
    $(emp_hist).attr('disabled', false)

  next_input_true = (next_emp_hist) ->
    $(next_emp_hist).css 'display', 'block'
    $(next_emp_hist).attr('disabled', false)

  if $(emp_hist1).val()
    $(emp_hist1).css('border-bottom', successful)
    $(emp_hist2).attr('disabled', false)
  else
    $(emp_hist1).keyup ->
      employment_history_validate emp_hist1, emp_hist2

  if $(emp_hist2).val()
    present_emp emp_hist2
    next_input_true emp_hist3
  else
    $(emp_hist2).keyup ->
      employment_history_validate emp_hist2, emp_hist3
      if $(this).val()
        $(emp_hist3).css 'display', 'block'
      else
        $(emp_hist3).css 'display', 'none'

  if $(emp_hist3).val()
    present_emp emp_hist3
    next_input_true emp_hist4
  else
    $(emp_hist3).keyup ->
      employment_history_validate emp_hist3, emp_hist4
      if $(this).val()
        $(emp_hist4).css 'display', 'block'
      else
        $(emp_hist4).css 'display', 'none'

  if $(emp_hist3).val()
    present_emp emp_hist4
  else
    $(emp_hist4).keyup ->
      employment_history_validate emp_hist4
