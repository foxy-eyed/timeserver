class TimeServer < Server
  def self.cache
    @cache ||= Cache.new
  end

  def serve(client)
    app = Application.new(client)
    app.run
  end
end
