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
      result << "#{location}: #{time_zone.inspect}" unless time_zone.nil?
    end
  end

  private

  def fetch_tz(location)
    coordinates = geocode(location)
    return if coordinates.nil?

    gtz = request_gtz(coordinates)
    return unless gtz.success?

    gtz.time_zone_id
  end

  def request_gtz(coordinates)
    params = coordinates
    params << { key: ENV['API_KEY'] } if ENV['API_KEY']
    GoogleTimezone.fetch(*params)
  end

  def geocode(location)
    config = {
        lookup: :google,
        cache: Redis.new
    }
    if ENV['API_KEY']
      config[:api_key] = ENV['API_KEY']
      config[:use_https] = true
    end
    Geocoder.configure(config)
    Geocoder.coordinates(location)
  end
end
