class modal {
  static get bs() {
    let el = find("#modal")
    return bootstrap.Modal.getInstance(el) || new bootstrap.Modal(el)
  }

  static show() {
    this.bs.show()
  }

  static close() {
    this.bs.hide()
  }

  static openUrl(url) {
    this.show()
    fetchText(url).then(text => {
      find("#modal .modal-body").innerHTML = text
      executeScriptsFrom(parseDocument(text))
    })
  }
}

onEvent("click", ".modal-link", (ev, el) => {
  if (ev.ctrlKey || ev.metaKey) { return } // new tab

  ev.preventDefault()
  modal.openUrl(el.dataset.url || el.href)
})

onEvent("hidden.bs.modal", ".modal", (ev, el) => {
  el.find(".modal-body").innerHTML = ""
})
