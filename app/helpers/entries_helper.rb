module EntriesHelper
  def css_class_for_entry(entry)
    classes = ["entry", entry.id]
    classes << "is_read" if entry.is_read?
    classes << "is_starred" if entry.is_starred?
    classes.sort.join(" ")
  end

  def link_to_entries_filter(type)
    url   = url_for(type: type, category_id: params[:category_id])
    klass = (@filter.type == type ? "btn-primary" : "btn-outline-primary")

    # TODO : i18n
    link_to t(".filters.#{type}"), url, class: "btn #{klass}"
  end
end
