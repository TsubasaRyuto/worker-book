$(document).on 'ready turbolinks:load', ->
  $('#worker_profile_picture').change ->
    if !this.files.length
      return

    file = $(this).prop('files')[0]
    file_reader = new FileReader()
    file_reader.onload = ->
      $('#preview').attr('src', file_reader.result )

    file_reader.readAsDataURL(file)
