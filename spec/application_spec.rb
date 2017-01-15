require 'spec_helper'

RSpec.describe Application do
  let(:client) { double('client') }
  let(:request) { Request.new(File.open("./spec/stubs/#{stub}")) }
  let(:app) { Application.new(client) }

  describe '#run' do
    before do
      @now = Time.now.utc
      allow(Time).to receive(:now) { @now }
      allow(Request).to receive(:new).and_return(request)
    end

    context 'with valid requests' do
      let!(:stub) { 'valid.txt' }
      let!(:response) { Response.new(200, "UTC: #{@now.strftime '%Y-%m-%d %H:%M:%S'}") }

      it 'runs TimeConverter and response with status 200' do
        expect(TimeConverter).to receive(:new).with(request.params).and_call_original
        expect(client).to receive(:<<).with(response.prepare)
        app.run
      end
    end

    context 'with invalid requests' do
      let!(:stub) { 'invalid.txt' }
      let!(:response) { Response.new(404, 'Not Found') }

      it 'responds with status 404' do
        expect(TimeConverter).to_not receive(:new)
        expect(client).to receive(:<<).with(response.prepare)
        app.run
      end
    end
  end
end
