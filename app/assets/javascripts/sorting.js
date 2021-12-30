onEvent("turbo:load turbo:render", () => {
  findAll(".sortable").forEach(container => {
    let options = {
      handle: ".handle",
      animation: 150,
      onSort: () => container.triggerEvent("sortupdate"),
    }
    container.Sortable ||= new Sortable(container, options)
  })
})

onEvent("sortupdate", ".sortable", ev => {
  let i = 0
  ev.target.findAll("input[name*=position]").forEach(input => input.value = ++i)
})
