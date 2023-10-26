class SimpleSerializer
  attr_reader :object, :options

  def self.call(...)
    new(...).call
  end

  def initialize(object, options = {})
    @object  = object
    @options = options
  end

  def call
    if object.is_a?(Hash)
      object.to_h { |k, v| [k.to_s, serialize(v)] }
    elsif object.is_a?(Enumerable)
      object.map { |e| serialize(e) }
    elsif (serializer = "#{object.class}Serializer".safe_constantize)
      serializer.call(object, options)
    else
      object.as_json
    end
  end

  private

  def serialize(object)
    SimpleSerializer.call(object, options)
  end
end
