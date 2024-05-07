# frozen_string_literal: true

module Perilune
  class Configuration
    attr_accessor :queue_name, :stat_driver

    def initialize
      @queue_name = :default
      @stat_driver = ::Trifle::Stats::Driver::Redis.new(::Redis.new)
    end

    def stats_driver_config
      config = ::Trifle::Stats::Configuration.new
      config.driver = @stat_driver
      config.time_zone = 'GMT'
      config.beginning_of_week = :monday
      config.track_ranges = %i[hour day week month quarter year]
      config
    end
  end
end
