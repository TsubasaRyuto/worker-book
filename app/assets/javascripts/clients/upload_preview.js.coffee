$(document).on 'change', '#client_logo', ->
  if !this.files.length
    return

  file = $(this).prop('files')[0]
  file_reader = new FileReader()
  file_reader.onload = ->
    $('#preview_logo').attr('src', file_reader.result )

  file_reader.readAsDataURL(file)
