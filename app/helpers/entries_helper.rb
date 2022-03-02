module EntriesHelper
  def css_class_for_entry(entry)
    classes = ["entry"]
    classes << "is_read" if entry.is_read?
    classes << "is_starred" if entry.is_starred?
    classes.sort.join(" ")
  end

  def link_to_entries_filter(filter, type)
    url = url_for filter.to_h.merge(type:)

    class_names = %w(btn btn-sm btn-outline-primary filter)
    class_names << type
    class_names << "active" if filter.type == type

    link_to t(".filters.#{type}"), url, class: class_names
  end

  def entries_path_for(filter, options)
    main_app.entries_path(filter.to_h.merge(options))
  end
end
