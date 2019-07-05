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

  ResponseNotOkError = Class.new(HTTP::ResponseError)

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
      .headers(user_agent: "Minifeed RSS Reader")
      .headers(accept: "*/*")
      .use(instrumentation: {instrumenter: ResponseNotOkInstrumenter.new})
  end

  def self.request(*args)
    http.request(*args)
  end
end
