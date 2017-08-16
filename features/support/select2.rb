module CapybaraSelect2
  def select2(selector, query, label = query)
    selector = "##{selector}" if selector.is_a?(Symbol)
    find("#{selector} + .select2-container").click
    find(".select2-search__field").set(query.to_s)
    find(".select2-results li", text: label.to_s).click
  end
end

World(CapybaraSelect2)
