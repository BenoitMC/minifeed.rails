module FormHelper
  def i18n_select(model, attribute)
    model.public_send(attribute.to_s.pluralize).keys.index_by { model.t("#{attribute}.#{_1}") }
  end
end
