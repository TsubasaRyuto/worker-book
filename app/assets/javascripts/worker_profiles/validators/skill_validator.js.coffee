$(document).on 'turbolinks:load', ->
  valid = true
  invlaid = false
  min_warning = $('.skill-minimum-warning')
  create_btn = $('.create-worker-profile')
  tagit = $('.tagit')

  skill_validate = ->
    count = $('.tagit-hidden-field').length
    if count < 5
      tagit.css 'border', '2px solid #dc143c'
      min_warning.css 'color', '#dc1432'
      min_warning.css 'display', 'block'
      create_btn.attr('disabled', true)
    else if count == 10
      $('.skiltal-max-warning').css 'display', 'block'
    else
      tagit.css 'border', '2px solid #486d94'
      min_warning.css 'display', 'none'
      create_btn.attr('disabled', false)

  if $('.tagit-hidden-field').val() && $('.tagit-hidden-field').length >= 5
    create_btn.attr('disabled', false)

  $('.ui-autocomplete-input').on 'keydown', (e) ->
    skill_validate()
    if e.keyCode == 8 || e.keyCode == 46 && count < 6　
      tagit.css 'border', '2px solid #dc143c'
      min_warning.css 'color', '#dc1432'
      min_warning.css 'display', 'block'
      create_btn.attr('disabled', true)

  $('ul').on 'click', '.ui-menu-item', ->
    skill_validate()
  $('ul').on 'click', 'a', ->
    count = $('.tagit-hidden-field').length
    # clickイベント発火時にはcount==5であるため、count<6としている
    if count < 6
      tagit.css 'border', '2px solid #dc143c'
      min_warning.css 'color', '#dc1432'
      min_warning.css 'display', 'block'
      create_btn.attr('disabled', true)
