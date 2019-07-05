$(document).on "turbolinks:load", ->
  $(".sortable").map ->
    container = this

    new Sortable container,
      handle: ".handle"
      animation: 150
      onSort: -> $(container).trigger("sortupdate")

$(document).on "sortupdate", ".sortable", ->
  i = 0
  $(this).find("input[name*=position]").map -> this.value = (i = i + 1)
