$(document).on 'turbolinks:load', ->
  valid = true
  invlaid = false
  min_warning = $('.skill-minimum-warning')
  create_btn = $('.create-worker-profile')
  tagit = $('.tagit')

  skill_validate = ->
    count = $('.tagit-choice').length
    if count < 5
      tagit.css 'border', '2px solid #dc143c'
      min_warning.css 'color', '#dc1432'
      min_warning.css 'display', 'block'
    else if count == 10
      $('.skiltal-max-warning').css 'display', 'block'
    else
      tagit.css 'border', '2px solid #486d94'
      min_warning.css 'display', 'none'

  $('.ui-autocomplete-input').on 'keydown', (e) ->
    skill_validate()
    # deleteボタンでタグが５以下になった時にスタイルをwarningにする
    # count = $('.tagit-choice').length
    # if e.keyCode == 8 or e.keyCode == 46 and count < 6
    #   console.log(count)
    #   tagit.css 'border', '2px solid #dc143c'
    #   min_warning.css 'color', '#dc1432'
    #   min_warning.css 'display', 'block'

  $('ul').on 'click', '.ui-menu-item', ->
    skill_validate()

  $('ul').on 'click', 'a', ->
    count = $('.tagit-choice').length
    # clickイベント発火時にはcount==5であるため、count<6としている
    if count < 6
      tagit.css 'border', '2px solid #dc143c'
      min_warning.css 'color', '#dc1432'
      min_warning.css 'display', 'block'
