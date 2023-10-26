module FontAwesomeHelper
  def fa_s(id, **)
    _fa_icon(id, fa_style: "fas", **)
  end

  def fa_r(id, **)
    _fa_icon(id, fa_style: "far", **)
  end

  def _fa_icon(id, fa_style:, size: nil, spin: false, **options)
    id = id.to_s.tr("_", "-").to_sym

    css_classes = options.delete(:class).to_s.split
    css_classes << "icon"
    css_classes << "fa-#{id}"
    css_classes << fa_style
    css_classes << "fa-#{size}" if size
    css_classes << "fa-spin" if spin

    attributes = options.merge(class: css_classes.sort.join(" ")).sort.to_h

    tag.span(**attributes)
  end
end
