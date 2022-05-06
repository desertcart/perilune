# frozen_string_literal: true

module Perilune
  class Configuration
    attr_accessor :queue_name, :stat_driver

    def initialize
      @queue_name = :default
      @stat_driver = ::Trifle::Stats::Driver::Redis.new
      @stat_track_ranges = %i[hour day week month quarter year]
      @stat_time_zone = 'GMT'
      @stat_beginning_of_week = :monday
    end

    def stats_driver_config
      config = ::Trifle::Stats::Configuration.new
      config.driver = @stat_driver
      config.time_zone = @stat_time_zone
      config.beginning_of_week = @stat_beginning_of_week
      config.track_ranges = @stat_track_ranges
      config
    end
  end
end
