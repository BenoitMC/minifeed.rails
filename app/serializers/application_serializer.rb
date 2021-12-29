class ApplicationSerializer < BMC::MiniModelSerializer::Serializer
  def current_user
    options[:current_user]
  end
end
