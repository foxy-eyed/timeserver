require_relative '../lib/request'

RSpec.describe Request do
  let(:socket) { double('socket') }
  let(:request) { Request.new(socket) }

  before { allow(socket).to receive(:gets).and_return(first_line) }

  describe 'extract location array from query' do
    context 'when query string is empty' do
      let!(:first_line) { "GET /time HTTP/1.1\r\n" }
      it 'params is empty array' do
        expect(request.params).to be_a Array
        expect(request.params).to be_empty
      end
    end

    context 'when query string is no empty' do
      let!(:first_line) { "GET /time?Samara,Moscow HTTP/1.1\r\n" }
      it 'params includes each location from query string' do
        %w(Samara Moscow).each do |location|
          expect(request.params).to be_include location
        end
      end
    end
  end

  describe '#permitted?' do
    context 'when path is valid' do
      let!(:first_line) { "GET /time HTTP/1.1\r\n" }
      it 'returns true' do
        expect(request).to be_permitted
      end
    end

    context 'when path is invalid' do
      let!(:first_line) { "GET /invalid-path HTTP/1.1\r\n" }
      it 'returns false' do
        expect(request).to_not be_permitted
      end
    end
  end
end
