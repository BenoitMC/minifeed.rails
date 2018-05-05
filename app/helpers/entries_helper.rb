module EntriesHelper
  def css_class_for_entry(entry)
    classes = ["entry", entry.id]
    classes << "is_read" if entry.is_read?
    classes << "is_starred" if entry.is_starred?
    classes.sort.join(" ")
  end
end
