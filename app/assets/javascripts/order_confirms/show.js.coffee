# 依頼受諾
$(document).on 'click', '#send-agreement', ->
  $("#agreement-password-confirm").modal("show")

$(document).on 'click', '.close, .close-btn', ->
  $("#agreement-password-confirm").modal("hide")

# 依頼キャンセル
$(document).on 'click', '#send-refusal', ->
  $("#refusal-password-confirm").modal("show")

$(document).on 'click', '.close, .close-btn', ->
  $("#refusal-password-confirm").modal("hide")
