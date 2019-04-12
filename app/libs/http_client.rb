module HttpClient
  ResponseNotOkError = Class.new(HTTP::Error)

  class ResponseNotOkInstrumenter < HTTP::Features::Instrumentation::NullInstrumenter
    def finish(name, payload)
      return unless name == "request.http"

      response = payload[:response]

      unless response.code.to_s.start_with?("2", "3")
        raise ResponseNotOkError, "Invalid response: #{response.code} #{response.reason}"
      end
    end
  end

  def self.http
    HTTP
      .follow
      .timeout(10)
      .headers(user_agent: "Firefox")
      .headers(accept_language: "fr")
      .use(instrumentation: {instrumenter: ResponseNotOkInstrumenter.new})
  end

  def self.method_missing(*args) # rubocop:disable Style/MethodMissingSuper
    http.send(*args)
  end

  def self.respond_to_missing?(*args)
    http.send(:respond_to?, *args) || http.send(:respond_to_missing?, *args)
  end
end
