$(document).on 'ready turbolinks:load', ->
  $('#type-skill').tagit
    placeholderText: '求めるスキル・言語',
    tagLimit: 5,
    singleField: true,
    showAutocompleteOnFocus : true,
    fieldName: 'skill',
    autocomplete: {delay: 0, minLength: 1, autoFocus: true},
    tagSource: (req, res) ->
      $.ajax
        url: "/autocomplete_skill/" + encodeURIComponent(req.term),
        dataType: "json",
        success: (data) ->
          if data.length == 0
            $('.ui-widget-content').val('')
            return false
          else
            res(data)
  if $('.ui-autocomplete-input').length == 2
    $('.ui-autocomplete-input').first().remove()

  if gon.skills?
    for skill in gon.skills
      $('#type-skill').tagit 'createTag', skill
