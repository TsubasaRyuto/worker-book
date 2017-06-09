$(document).on 'ready turbolinks:load', ->
  $('#job-content-skill-field').tagit
    placeholderText: 'Type Here......',
    tagLimit: 10,
    singleField: true,
    showAutocompleteOnFocus : true,
    fieldName: 'job_content[skill_list]',
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
  if gon.job_content_skills?
    for skill in gon.job_content_skills
      $('#job-content-skill-field').tagit 'createTag', skill
