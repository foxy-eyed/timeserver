require 'uri'

class Request
  attr_reader :socket, :params

  def initialize(socket)
    @socket = socket
    parse
  end

  def permitted?
    /^\/time(\?.*)?$/.match(@path) != nil
  end

  private

  def parse
    extract_path
    extract_params if permitted?
  end

  def extract_path
    @path = data.first.split(' ')[1]
  end

  def extract_params
    @params = []
    query = URI.parse(@path).query
    @params = URI.decode(query).split(',') if query
  end

  def data
    data = []
    while (line = socket.gets).chomp! != ''
      data << line
    end
    data
  end
end
