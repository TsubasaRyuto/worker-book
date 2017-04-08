$ ->
  employment_history_validate = (employment_history, next) ->
    company_name = $(employment_history).val()
    if company_name.length > 2
      $(employment_history).css('border-bottom', '3px solid #486d94')
      $(next).attr('disabled', false)
    else
      $(employment_history).css('border-bottom', '1px solid #808080')
      $(next).attr('disabled', true)

  $('.employment-history1').keyup ->
    employment_history_validate '.employment-history1', '.employment-history2'

  $('.employment-history2').keyup ->
    employment_history_validate '.employment-history2', '.employment-history3'
    if $(this).val()
      $('.employment-history3').css 'display', 'block'
    else
      $('.employment-history3').css 'display', 'none'

  $('.employment-history3').keyup ->
    employment_history_validate '.employment-history3', '.employment-history4'
    if $(this).val()
      $('.employment-history4').css 'display', 'block'
    else
      $('.employment-history4').css 'display', 'none'

  $('.employment-history4').keyup ->
    employment_history_validate '.employment-history4'
