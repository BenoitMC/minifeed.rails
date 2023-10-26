module ApplicationHelper
  def boolean_icon(bool)
    return if bool.nil?
    raise ArgumentError, "#{bool} is not a boolean" if [true, false].exclude?(bool)

    if bool
      fa_s(:check, style: "color: green")
    else
      fa_s(:times, style: "color: red")
    end
  end
end
