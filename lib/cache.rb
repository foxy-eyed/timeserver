require 'redis'

class Cache < Redis
  def get(location)
    super(cache_key_for(location))
  end

  def set(location, value, options = {})
    super(cache_key_for(location), value, options)
  end

  private

  def cache_key_for(location)
    key = location.downcase
    key.gsub!(/[[:punct:]]/, '_'.freeze)
    key.gsub!(/[\s]/, '_'.freeze)
    ['city:', key].join
  end
end