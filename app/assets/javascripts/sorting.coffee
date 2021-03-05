onEvent "turbo:load", ->
  findAll(".sortable").forEach (container) ->
    new Sortable container,
      handle: ".handle"
      animation: 150
      onSort: -> container.triggerEvent("sortupdate")

onEvent "sortupdate", ".sortable", ->
  i = 0
  this.findAll("input[name*=position]").forEach (input) -> input.value = (i = i + 1)
