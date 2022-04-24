# frozen_string_literal: true

module Perilune
  module Trifle
    class Stat
      def self.configuration
        config = ::Trifle::Stats::Configuration.new
        config.driver = Perilune.default.trifle_stat_driver
        config.track_ranges = Perilune.default.trifle_stat_track_ranges
        config.time_zone = Perilune.default.trifle_stat_time_zone
        config.beginning_of_week = Perilune.default.trifle_stat_beginning_of_week
        config
      end
    end
  end
end
