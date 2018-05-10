$(document).on "click", ".entry-preview_link", (event) ->
  event.preventDefault()
  $iframe = $("<iframe src='#{this.href}' class='entry-iframe' />")
  $iframe.load -> this.style.height = this.contentDocument.body.scrollHeight + "px"
  $(this).parents("#entry").find(".entry-content").html($iframe)

$(document).on "click", ".entry-internal_link", (event) ->
  event.preventDefault()
  $iframe = $("<iframe src='#{this.href}' class='entry-iframe' />")
  $(this).parents("#entry").find(".entry-content").html($iframe)

$(document).on "click", "a[data-entry-id]", ->
  window.currentEntryId = this.dataset.entryId

$(document).on "modal:close", ->
  window.currentEntryId = null

$(document).on "click", "#entries-load-more a", (event) ->
  event.preventDefault()
  $.ajax
    url: this.href
    success: (data) ->
      $data = $("<div>#{data}</div>")
      $("#entries-list").append $data.find("#entries-list").html()
      $("#entries-load-more").replaceWith $data.find("#entries-load-more")

Mousetrap.bind "right", ->
  return unless try currentEntryId
  $("a[data-entry-id=#{currentEntryId}]").parents("li").next("li").find("a[data-entry-id]").click()

Mousetrap.bind "left", ->
  return unless try currentEntryId
  $("a[data-entry-id=#{currentEntryId}]").parents("li").prev("li").find("a[data-entry-id]").click()

Mousetrap.bind "r", ->
  $("#entry input[type=checkbox][name*=read]").map -> $(this).prop(checked: !this.checked).change()

Mousetrap.bind "s", ->
  $("#entry input[type=checkbox][name*=starred]").map -> $(this).prop(checked: !this.checked).change()

Mousetrap.bind "p", ->
  $("#entry .entry-preview_link").click()

Mousetrap.bind "m", ->
  try $("#entry .entry-internal_link").get(0).click()

Mousetrap.bind "o", ->
  try $("#entry .entry-external_link").get(0).click()

$(document).on "click", ".entry-body a", ->
  this.target = "_blank"

$(document).on "change", "#entry > form", ->
  $(this).submit()

$(document).on "ajax:complete", "#entry > form", (event, xhr) ->
  $data = $("<div>#{xhr.responseText}</div>")
  $("#entry .entry-header").replaceWith $data.find("#entry .entry-header")
  $data.find("script").map -> eval(this.innerHTML)

@reloadNavigation = ->
  $.ajax
    url: location.href
    data: {layout: true}
    success: (data) -> $("#header").replaceWith $("<div>#{data}</div>").find("#header")

$(document).on "click", ".subnav-toggle", (event) ->
  event.preventDefault()
  $(this).parents(".subnav").toggleClass("open")
