require 'socket'
require_relative 'lib/server'
require_relative 'lib/time_converter'

class TimeServer < Server
  def serve(client)
    converter = TimeConverter.new(['Moscow', 'New York'])
    converter.run
    client.puts converter.result.join("\n")
  end
end

TimeServer.new(2000)
