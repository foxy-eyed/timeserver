Dir['./lib/*.rb'].each { |f| require f }

TimeServer.new(2000)
