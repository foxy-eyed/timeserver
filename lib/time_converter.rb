require 'geocoder'
require 'google_timezone'
require 'redis'
require 'tzinfo'

class TimeConverter
  attr_reader :current_utc, :locations, :output_format, :result

  def initialize(locations = [], output_format = '%Y-%m-%d %H:%M:%S')
    @current_utc = Time.now.utc
    @locations = locations
    @output_format = output_format
    @cache = Redis.new
  end

  def run
    @result = ["UTC: #{current_utc.strftime output_format}"]
    locations.each do |location|
      time_zone = time_zone(location)
      result << "#{location}: #{apply_tz(time_zone)}"
    end
  end

  private

  def time_zone(location)
    time_zone = @cache.get(cache_key_for(location))
    time_zone = fetch_tz(location) if time_zone.nil?
    time_zone
  end

  def cache_key_for(location)
    key = location.downcase
    key.gsub!(/[[:punct:]]/, '_'.freeze)
    key.gsub!(/[\s]/, '_'.freeze)
    ['city:', key].join
  end

  def fetch_tz(location)
    coordinates = geocode(location)
    return if coordinates.nil?

    gtz = request_gtz(coordinates)
    return unless gtz.success?

    @cache.set(cache_key_for(location), gtz.time_zone_id)
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
        cache: @cache
    }
    if ENV['API_KEY']
      config[:api_key] = ENV['API_KEY']
      config[:use_https] = true
    end
    Geocoder.configure(config)
    Geocoder.coordinates(location)
  end

  def apply_tz(time_zone)
    return 'unknown' if time_zone.nil?
    tz = TZInfo::Timezone.get(time_zone)
    tz.utc_to_local(current_utc).strftime(output_format)
  end
end
