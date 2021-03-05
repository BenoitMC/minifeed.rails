HTMLElement.prototype.find = HTMLElement.prototype.querySelector
HTMLElement.prototype.findAll = HTMLElement.prototype.querySelectorAll

HTMLElement.prototype.onEvent = (name, selector, handler) ->
  if typeof(selector) == "function" && handler == undefined
    return this.addEventListener(name, selector)

  this.addEventListener name, (event) ->
    el = event.target
    el = el.parentElement while el && !el.matches(selector)
    handler.bind(el)(event) if el

HTMLElement.prototype.triggerEvent = (eventName) ->
  event = document.createEvent("Event")
  event.initEvent(eventName, true, true)
  this.dispatchEvent(event)
  return this

@find = document.querySelector.bind(document)
@findAll = document.querySelectorAll.bind(document)
@onEvent = HTMLElement.prototype.onEvent.bind(document)

@parseDocument = (str) ->
  (new DOMParser).parseFromString(str, "text/html").body

@parseFragment = (str) ->
  parseDocument(str).firstChild

@executeScriptsFrom = (el) ->
  el.findAll("script").forEach (e) -> eval(e.innerHTML)

@fetchText = (url) ->
  fetch(url, headers: {"X-Requested-With": "XMLHttpRequest"})
    .then (response) -> response.text()
