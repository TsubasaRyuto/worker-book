$ ->
  $('.appeal-note').focus ->
    $('.note-info').css 'display', 'block'

  $('.appeal-note').blur ->
    $('.note-info').css 'display', 'none'

  $('.appeal-note').keyup ->
      MAX_LENGTH = 3000
      MIN_LENGTH = 400
      colorWarning = '#dc143c'
      colorSuccess = '#486d94'
      noteValueLength = $(this).val().length

      $('.count-charcters').html noteValueLength

      if noteValueLength <= MIN_LENGTH
        $('.appeal-note').css 'border', "2px solid #{colorWarning}"
        $('.count-charcters').css 'color', colorWarning
      else if MAX_LENGTH < noteValueLength
        $('.appeal-note').css 'border', "2px solid #{colorWarning}"
        $('.count-charcters').css 'color', colorWarning
      else
        $('.appeal-note').css 'border', "2px solid #{colorSuccess}"
        $('.count-charcters').css 'color', colorSuccess
