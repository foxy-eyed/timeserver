require 'spec_helper'

RSpec.describe Request do
  let(:request) { Request.new(File.open("./spec/stubs/#{stub}")) }

  describe 'extract location array from query' do
    context 'when query string is empty' do
      let!(:stub) { 'valid.txt' }
      it 'params is empty array' do
        expect(request.params).to be_a Array
        expect(request.params).to be_empty
      end
    end

    context 'when query string is no empty' do
      let!(:stub) { 'valid_with_query.txt' }
      it 'params includes each location from query string' do
        %w(Samara Moscow).each do |location|
          expect(request.params).to be_include location
        end
      end
    end
  end

  describe '#permitted?' do
    context 'when path is valid' do
      let!(:stub) { 'valid.txt' }
      it 'returns true' do
        expect(request).to be_permitted
      end
    end

    context 'when path is invalid' do
      let!(:stub) { 'invalid.txt' }
      it 'returns false' do
        expect(request).to_not be_permitted
      end
    end
  end
end
