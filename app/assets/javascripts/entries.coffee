$(document).on "click", ".entry-preview_link", (event) ->
  event.preventDefault()
  $iframe = $("<iframe src='#{this.href}' class='entry-iframe' />")
  $(this).parents("#entry").find(".entry-body").replaceWith($iframe)
