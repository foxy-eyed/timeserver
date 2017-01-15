Dir['./lib/*.rb'].each { |f| require f }

class TimeServer < Server
  def serve(client)
    app = Application.new(client)
    app.run
  end
end

TimeServer.new(2000)
