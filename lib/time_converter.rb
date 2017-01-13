require 'geocoder'
require 'google_timezone'
require 'redis'

class TimeConverter
  attr_reader :locations, :result

  def initialize(locations = [])
    @locations = locations
  end

  def run
    @result = []
    locations.each do |location|
      time_zone = fetch_tz(location)
      result << "#{location}: #{time_zone}" unless time_zone.nil?
    end
  end

  private

  def fetch_tz(location)
    coordinates = geocode(location)
    return if coordinates.nil?

    gtz = GoogleTimezone.fetch(coordinates)
    return unless gtz.success?

    gtz.time_zone_id
  end

  def geocode(location)
    Geocoder.configure(cache: Redis.new)
    Geocoder.coordinates(location)
  end
end
