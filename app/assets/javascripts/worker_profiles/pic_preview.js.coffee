# 
# $ ->
#   $('.picture-upload:file').change ->
#     file = $(this).prop('files')[0]
#     reader = new FileReader()
#     preview = $('.preview')
#
#     if !file.type.match('image.')
#       $(this).val('')
#       return false
#
#     reader.onload = (event) ->
#       preview.append($('<img>').attr {
#         src: event.target.result,
#         width: '150px',
#         id: 'picture-preview',
#         title: file.name
#         })
#     reader.readAsDataURL(file)
