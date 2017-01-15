require 'spec_helper'

RSpec.describe Response do
  describe '#prepare' do
    response_types = { 200 => 'OK',
                 404 => 'Not Found',
                 500 => 'Internal Server Error' }

    response_types.each do |code, status_text|
      let(:response) { Response.new(code, status_text) }
      let(:template) {
        "HTTP/1.1 #{code} #{status_text} \r\n" +
        "Server: TimeServer\r\n" +
        "Content-Type: text/plain\r\n" +
        "Content-Length: #{status_text.bytesize}\r\n" +
        "Connection: close\r\n\r\n" +
        "#{status_text}"
      }
      it "generates valid response with status #{code}" do
        expect(response.prepare).to eq(template)
      end
    end
  end

  describe '#send_response' do
    let(:client) { double('client') }
    let(:response) { Response.new(200, 'Some Body') }

    it 'sends data to client' do
      expect(client).to receive(:<<).with(response.prepare)
      response.send_response(client)
    end
  end
end
