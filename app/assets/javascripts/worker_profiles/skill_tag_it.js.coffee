$ ->
  $('#worker-skill-field').tagit
    placeholderText: 'Type Here......',
    tagLimit: 10,
    showAutocompleteOnFocus : true,
    fieldName: 'worker_skill[skill_language_id][]'
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
            res $.map(data, (item) ->
              # skill_language_idを取得する為に、valueでidを取得し、tag-it.jsで指定している。
              value: item.id
              label: item.name
            )
