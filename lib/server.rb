require 'socket'
require 'thread'

class Server

  DEFAULT_HOST = '127.0.0.1'

  attr_reader :port, :host, :max_connections,:connections

  def initialize(port, host = DEFAULT_HOST, max_connections = 4)
    @port = port
    @host = host
    @max_connections = max_connections
    @connections = []
    @mutex = Mutex.new
    @cv = ConditionVariable.new
    start
  end

  protected

  def start
    server = TCPServer.new(@host, @port)
    loop do
      @mutex.synchronize {
        until @connections.size < @max_connections
          @cv.wait(@mutex)
        end
      }
      Thread.start(server.accept) do |client|
        @connections << Thread.current
        begin
          serve(client)
        ensure
          client.close
          @mutex.synchronize {
            @connections.delete(Thread.current)
            @cv.signal
          }
        end
      end
    end
    self
  end

  def serve(client)
  end
end
