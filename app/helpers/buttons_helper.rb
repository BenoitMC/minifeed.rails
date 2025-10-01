module ButtonsHelper
  DEFAULT_SIZE = :sm
  DEFAULT_STYLE = :outline_primary

  def bs_button(
    url,
    icon:,
    method: :get,
    confirm: nil,
    text: nil,
    action: nil,
    title: text,
    btn_size: DEFAULT_SIZE,
    btn_style: DEFAULT_STYLE,
    add_class: [],
    **options
  )
    text = ta(action) if text.nil? && action

    content = fa_s(icon).concat(" ").concat(tag.span(text, class: "text"))

    if method != :get
      options[:"data-turbo-method"] = method
      confirm = true if confirm.nil?
    end

    unless options[:class]
      options[:class] = [
        "btn",
        "btn-#{btn_size}",
        "btn-#{btn_style.to_s.tr('_', '-')}",
        ("link-#{action}" if action),
        *add_class,
      ]
    end

    options[:title] = title

    unless confirm.nil?
      confirm = ta(:confirm) if confirm == true
      options.deep_merge!("data-turbo-confirm": confirm)
    end

    link_to(content, url, options.sort.to_h)
  end

  def new_button(url = url_for(action: :new), **options)
    options = {
      icon: :plus,
      action: :new,
      btn_style: :success,
    }.merge(options)

    bs_button(url, **options)
  end

  def edit_button(url, **options)
    options = {
      icon: :pencil_alt,
      action: :edit,
    }.merge(options)

    bs_button(url, **options)
  end

  def delete_button(url, **options)
    options = {
      icon: :trash,
      action: :delete,
      btn_style: :danger,
      method: :delete,
    }.merge(options)

    bs_button(url, **options)
  end
end
