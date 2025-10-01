module HttpClient
  Error = Module.new

  [
    HTTP::Error,
    IOError,
    OpenSSL::SSL::SSLError,
    SocketError,
    SystemCallError,
    Timeout::Error,
    Zlib::Error,
  ].each { |exception| exception.send(:include, Error) }

  DEFAULT_USER_AGENT = "Minifeed RSS Reader".freeze

  ResponseNotOkError = Class.new(HTTP::ResponseError)

  class ResponseNotOkInstrumenter < HTTP::Features::Instrumentation::NullInstrumenter
    def finish(name, payload)
      return unless name == "request.http"

      response = payload[:response]

      return if response.code.to_s.start_with?("2", "3")

      raise ResponseNotOkError, "Invalid response: #{response.code} #{response.reason}"
    end
  end

  def self.http
    HTTP
      .follow
      .timeout(10)
      .headers(user_agent: DEFAULT_USER_AGENT)
      .headers(accept: "*/*")
      .use(instrumentation: { instrumenter: ResponseNotOkInstrumenter.new })
  end

  def self.request(...)
    http.request(...)
  end
end
