class Response
  CRLF = "\r\n".freeze

  DEFAULT_HEADER = { 'Server' => 'TimeServer',
                     'Content-Type' => 'text/plain' }

  MESSAGES = { 200 => 'OK',
               404 => 'Not Found',
               500 => 'Internal Server Error' }.freeze

  attr_reader :header, :body, :status

  def initialize(status, body)
    @status = status
    @body = body
    @header = DEFAULT_HEADER
    @header['Content-Length'] = @body ? @body.bytesize : 0
    @header['Connection'] = 'close'
  end

  def send_response(socket)
    socket << prepare
  end

  def prepare
    data = "HTTP/1.1 #{status} #{MESSAGES[status]} #{CRLF}"
    @header.each { |key, value| data << "#{key}: #{value}" << CRLF }
    data << CRLF
    data << body unless body.nil?
    data
  end
end
