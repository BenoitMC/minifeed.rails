$(document).on "click", ".entry-preview_link", (event) ->
  event.preventDefault()
  $iframe = $("<iframe src='#{this.href}' class='entry-iframe' />")
  $(this).parents("#entry").find(".entry-body").replaceWith($iframe)

$(document).on "click", "a[data-entry-id]", ->
  window.currentEntryId = this.dataset.entryId

$(document).on "modal:close", ->
  window.currentEntryId = null

Mousetrap.bind "right", ->
  return unless currentEntryId
  $("a[data-entry-id=#{currentEntryId}]").parents("li").next("li").find("a[data-entry-id]").click()

Mousetrap.bind "left", ->
  return unless currentEntryId
  $("a[data-entry-id=#{currentEntryId}]").parents("li").prev("li").find("a[data-entry-id]").click()

$(document).on "click", ".entry-body a", ->
  this.target = "_blank"

$(document).on "change", "#entry > form", ->
  $(this).submit()

$(document).on "ajax:complete", "#entry > form", (event, xhr) ->
  $("#entry").replaceWith(xhr.responseText)

@reloadNavigation = ->
  $.ajax
    url: location.href
    data: {layout: true}
    success: (data) -> $("#header").replaceWith $("<div>#{data}</div>").find("#header")
