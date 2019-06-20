module GSpreadsheetProtocol
  class Url
    attr_accessor :url

    def initialize(url: nil)
      @url = url
    end

    def self.valid?(url)
      self.new(url: url).valid?
    end

    def valid?
      client = HTTPClient.new
      res = client.get(@url, follow_redirect: true)
      return HTTP::Status.successful?(res.code)
    rescue SocketError, ArgumentError
      return false
    end
  end
end