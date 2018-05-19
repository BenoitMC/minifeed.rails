class ApplicationSerializer < Agilibox::MiniModelSerializer::Serializer
  def current_user
    options[:current_user]
  end
end
