require 'tzinfo'
require_relative '../lib/time_converter'

RSpec.describe TimeConverter do
  describe '#run' do
    before do
      @now = Time.now.utc
      allow(Time).to receive(:now) { @now }
    end

    context 'when locations not specified' do
      converter = TimeConverter.new
      converter.run

      it 'result is not empty array' do
        expect(converter.result).to be_a Array
        expect(converter.result).to_not be_empty
      end

      it 'retrieves UTC time and stores to result array' do
        expect(converter.result.first).to eq "UTC: #{@now.strftime converter.output_format}"
      end
    end

    context 'when locations not empty' do
      locations = {
          'Samara' => TZInfo::Timezone.get('Europe/Samara'),
          'Moscow' => TZInfo::Timezone.get('Europe/Moscow')
      }
      converter = TimeConverter.new(locations.keys)
      converter.run

      it 'result array size equals locations size + 1' do
        expect(converter.result.size).to eq locations.size + 1
      end

      it 'retrieves time for each location and stores to result array' do
        locations.each do |loc, tz|
          expect(converter.result).to be_include("#{loc}: #{tz.utc_to_local(@now).strftime converter.output_format}")
        end
      end
    end
  end
end
