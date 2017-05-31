$(document).on 'ready turbolinks:load', ->
  $('#job_content_title').focus ->
    $('.title-info').css 'display', 'block'
  .blur ->
    $('.title-info').css 'display', 'none'

  $('#job_content_content').focus ->
    $('.content-info').css 'display', 'block'
  .blur ->
    $('.content-info').css 'display', 'none'

  $('#job_content_note').focus ->
    $('.experience-seeking-info').css 'display', 'block'
  .blur ->
    $('.experience-seeking-info').css 'display', 'none'
