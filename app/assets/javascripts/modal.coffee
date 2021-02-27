@modal =
  show: ->
    $("#modal").modal("show")

  close: ->
    $("#modal").modal("hide")

  openUrl: (url) ->
    $("#modal .modal-body").load(url)
    modal.show()

$(document).on "click", ".modal-link", (e) ->
  e.preventDefault()
  modal.openUrl(this.href)

$(document).on "hidden.bs.modal", ".modal", ->
  $(this).find(".modal-body").html("")
