Then("I see {string} in a new tab") do |text|
  expect(windows.count > 1).to be true
  switch_to_window windows.last
  expect(page).to have_content(text)
end

Then("I see {string} before {string}") do |a, b|
  expect(source.index(a) < source.index(b)).to be true
end

Then("I reorder elements") do
  expect(page).to have_selector(".handle")

  evaluate_script %( $("tbody").append($("tbody tr").eq(0).detach()) )
  evaluate_script %( $(".sortable").trigger("sortupdate") )
end
