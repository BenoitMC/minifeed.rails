$(document).on "turbolinks:load", ->
  sortable ".sortable",
    forcePlaceholderSize: true
    handle: ".handle"
    items: ".sortable-item"

  $(".sortable").on "sortupdate", ->
    i = 0
    $(this).find("input[name*=position]").map -> this.value = (i = i + 1)
