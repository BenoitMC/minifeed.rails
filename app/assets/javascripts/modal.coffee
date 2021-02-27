@modal =
  show: ->
    $("#modal").modal("show")

  close: ->
    $("#modal").modal("hide")
    $("#modal .modal-body").html("")

  openUrl: (url) ->
    $("#modal .modal-body").load(url)
    modal.show()

$(document).on "click", ".modal-link", (e) ->
  e.preventDefault()
  modal.openUrl(this.href)
