Then("I see {string} in a new tab") do |text|
  wait_for { windows.count }.to be > 1
  switch_to_window windows.last
  expect(page).to have_content(text)
end

Then("I see {string} before {string}") do |a, b|
  expect(source.index(a) < source.index(b)).to be true
end

Then("I reorder elements") do
  expect(page).to have_selector(".handle")

  execute_script %( $("tbody").append($("tbody tr").eq(0).detach()) )
  execute_script %( $(".sortable").trigger("sortupdate") )
end

Then("I am signed in") do
  expect(page).to have_selector "#user-nav"
end
