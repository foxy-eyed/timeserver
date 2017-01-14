Dir['lib/*.rb'].each { |f| require_relative f }

class TimeServer < Server
  def serve(client)
    request = Request.new(client)
    if request.permitted?
      converter = TimeConverter.new(request.params)
      converter.run
      response = Response.new(200, converter.result.join("\n"))
    else
      response = Response.new(404, 'Not Found')
    end
  rescue Exception => e
    response = Response.new(500, e.message)
  ensure
    response.send_response(client)
  end
end

TimeServer.new(2000)
