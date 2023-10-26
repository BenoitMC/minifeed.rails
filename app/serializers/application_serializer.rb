class ApplicationSerializer < SimpleSerializer
  delegate_missing_to :object

  def call
    serialize(attributes.index_with { |k| send(k) })
  end

  def current_user
    options[:current_user]
  end
end
