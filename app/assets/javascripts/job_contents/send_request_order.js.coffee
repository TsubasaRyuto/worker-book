$(document).on 'click', '#send-request', ->
  $("#order-request").modal("show")

$(document).on 'click', '.close, .close-btn', ->
  $("#order-request").modal("hide")
