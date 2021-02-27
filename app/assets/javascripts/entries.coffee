@Minifeed ||= {}

Minifeed.current_entry_id = null

Minifeed.reload_navigation = ->
  $.ajax
    url: location.href
    data: {layout: true}
    success: (data) -> $("#header").replaceWith $("<div>#{data}</div>").find("#header")

$(document).on "click", ".entry-reader_link", (event) ->
  event.preventDefault()
  $iframe = $("<iframe src='#{this.href}' class='entry-iframe' />")
  $iframe.on "load", -> this.style.height = this.contentDocument.querySelector("html").scrollHeight + "px"
  $(this).parents("#entry").find(".entry-content").html($iframe)

$(document).on "click", ".entry-internal_link", (event) ->
  event.preventDefault()
  $iframe = $("<iframe src='#{this.href}' class='entry-iframe' />")
  $(this).parents("#entry").find(".entry-content").html($iframe)

$(document).on "click", "a[data-entry-id]", ->
  Minifeed.current_entry_id = this.dataset.entryId

$(document).on "modal:close", ->
  Minifeed.current_entry_id = null

$(document).on "click", "#entries-load-more a", (event) ->
  event.preventDefault()
  $.ajax
    url: this.href
    success: (data) ->
      $data = $("<div>#{data}</div>")
      $("#entries-list").append $data.find("#entries-list").html()
      $("#entries-load-more").replaceWith $data.find("#entries-load-more")

$(document).on "click", ".entry-body a", ->
  this.target = "_blank"

$(document).on "change", "#entry > form", ->
  Rails.fire(this, "submit")

$(document).on "ajax:complete", "#entry > form", (event) ->
  xhr = event.detail[0]
  $data = $("<div>#{xhr.responseText}</div>")
  $("#entry .entry-header").replaceWith $data.find("#entry .entry-header")
  $data.find("script").map -> eval(this.innerHTML)

$(document).on "click", ".subnav-toggle", (event) ->
  event.preventDefault()
  $(this).parents(".subnav").toggleClass("open")
