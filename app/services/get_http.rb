class GetHTTP < Service
  class Error < StandardError
  end

  EXCEPTIONS_TO_RERAISE = [
    Errno::ECONNABORTED,
    Errno::ECONNREFUSED,
    Errno::ECONNRESET,
    Errno::ENETRESET,
    Net::HTTPBadResponse,
    Net::HTTPError,
    Net::HTTPFatalError,
    Net::HTTPHeaderSyntaxError,
    Net::HTTPRetriableError,
    Net::HTTPServerException,
    Net::OpenTimeout,
    Net::ReadTimeout,
    OpenSSL::SSL::SSLError,
    SocketError,
    Timeout::Error,
  ]

  TIMEOUT = 10

  initialize_with :url

  def call
    response = Timeout.timeout(TIMEOUT) do
      Net::HTTP.get_response(URI(url.to_s))
    end

    if response.code.start_with?("3")
      @url = response["Location"]
      return call
    end

    unless response.code.start_with?("2")
      raise Error, "invalid response code : #{response.code}"
    end

    response.body
  rescue *EXCEPTIONS_TO_RERAISE => e
    raise Error, e.message
  end
end
