# Fix data-method + data-turbo=false links
# Should be fixed in 7.0.0
# https://github.com/hotwired/turbo/pull/3
onEvent "click", "body > form", (e) ->
  if e.explicitOriginalTarget?.dataset?.turbo == "false"
    this.dataset.turbo = "false"
