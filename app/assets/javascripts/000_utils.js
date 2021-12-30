HTMLElement.prototype.find = HTMLElement.prototype.querySelector
HTMLElement.prototype.findAll = HTMLElement.prototype.querySelectorAll

HTMLElement.prototype.onEvent = function (names, selector, handler) {
  let container = this

  names.split(" ").forEach(name => {
    if (typeof (selector) == "function" && handler === undefined) {
      return container.addEventListener(name, selector)
    }

    container.addEventListener(name, event => {
      let el = event.target
      while (el && el.matches && !el.matches(selector)) {
        el = el.parentElement
      }
      if (el instanceof Element) {
        handler.bind(el)(event, el)
      }
    })
  })

  return this
}

HTMLElement.prototype.triggerEvent = function (eventName) {
  let event = new Event(eventName, { bubbles: true, cancelable: true })
  this.dispatchEvent(event)
  return this
}

window.find = document.querySelector.bind(document)
window.findAll = document.querySelectorAll.bind(document)
window.onEvent = HTMLElement.prototype.onEvent.bind(document)

window.parseDocument = str =>
  (new DOMParser).parseFromString(str, "text/html").body

window.parseFragment = str =>
  parseDocument(str).firstChild

window.executeScriptsFrom = el =>
  el.findAll("script").forEach(e => eval(e.innerHTML))

window.fetchText = url =>
  fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
    .then(response => response.text())
