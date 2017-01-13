require 'socket'
require_relative 'lib/time_converter'

server = TCPServer.new 2000
loop do
  Thread.start(server.accept) do |client|
    converter = TimeConverter.new(['Moscow', 'New York'])
    converter.run
    client.puts converter.result.join("\n")
    client.close
  end
end
