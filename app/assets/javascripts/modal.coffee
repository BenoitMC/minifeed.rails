@modal =
  bs: ->
    el = find("#modal")
    bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el)

  show: ->
    modal.bs().show()

  close: ->
    modal.bs().hide()

  openUrl: (url) ->
    modal.show()
    fetchText(url)
      .then (text) ->
        find("#modal .modal-body").innerHTML = text
        executeScriptsFrom(parseDocument(text))

onEvent "click", ".modal-link", (e) ->
  e.preventDefault()
  modal.openUrl(this.href)

onEvent "hidden.bs.modal", ".modal", ->
  this.find(".modal-body").innerHTML = ""
