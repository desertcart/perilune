# frozen_string_literal: true

Trifle::Stats.configure do |config|
  config.driver = Trifle::Stats::Driver::Redis.new
  config.track_ranges = %i[hour day week month quarter year]
  config.time_zone = 'GMT'
  config.beginning_of_week = :monday
end
