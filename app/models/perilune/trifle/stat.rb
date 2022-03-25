# frozen_string_literal: true

module Perilune
  module Trifle
    class Stat
      # custom Redis configuration in addition to default config

      def self.redis_config
        config = Trifle::Stats::Configuration.new
        config.driver = Trifle::Stats::Driver::Redis.new
        config.track_ranges = %i[hour day week month quarter year]
        config.time_zone = 'GMT'
        config.beginning_of_week = :monday
        config
      end
    end
  end
end
