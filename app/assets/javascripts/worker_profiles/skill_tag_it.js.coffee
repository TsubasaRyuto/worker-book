$(document).on 'turbolinks:load', ->
  $('#worker-skill-field').tagit
    placeholderText: 'Type Here......',
    tagLimit: 10,
    singleField: true,
    showAutocompleteOnFocus : true,
    fieldName: 'worker_profile[skill_list]',
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
  if gon.worker_skills?
    for skill in gon.worker_skills
      $('#worker-skill-field').tagit 'createTag', skill
