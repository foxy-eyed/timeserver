class Application
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def run
    request = Request.new(client)
    if request.permitted?
      converter = TimeConverter.new(request.params)
      converter.run
      response = Response.new(200, converter.result.join("\n"))
    else
      response = Response.new(404, 'Not Found')
    end
  rescue => e
    response = Response.new(500, e.message)
  ensure
    response.send_response(client)
  end
end
