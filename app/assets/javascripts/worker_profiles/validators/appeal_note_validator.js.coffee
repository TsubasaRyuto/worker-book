$(document).on 'ready turbolinks:load', ->
  MAX_LENGTH = 3000
  MIN_LENGTH = 400
  note = '.appeal-note'
  info = '.note-info'
  count_char = '.count-charcters'
  color_warning = '#dc143c'
  color_success = '#486d94'

  count_style = (val_length) ->
    if val_length <= MIN_LENGTH
      $(note).css 'border', "2px solid #{color_warning}"
      $(count_char).css 'color', color_warning
    else if MAX_LENGTH < val_length
      $(note).css 'border', "2px solid #{color_warning}"
      $(count_char).css 'color', color_warning
    else
      $(note).css 'border', "2px solid #{color_success}"
      $(count_char).css 'color', color_success


  $(note).focus ->
    $(info).css 'display', 'block'

  $(note).blur ->
    $(info).css 'display', 'none'

  if $(note).val()
    first_note_val_length = $(note).val().length
    $(count_char).html first_note_val_length
    count_style first_note_val_length

  $(note).keyup ->
    note_val_length = $(this).val().length
    $(count_char).html note_val_length
    count_style note_val_length
