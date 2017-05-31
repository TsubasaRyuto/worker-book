$(document).on 'ready turbolinks:load', ->
  $('#client_logo').change ->
    if !this.files.length
      return

    file = $(this).prop('files')[0]
    file_reader = new FileReader()
    file_reader.onload = ->
      $('#preview').attr('src', file_reader.result )

    file_reader.readAsDataURL(file)
