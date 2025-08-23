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
      config.granularities = %w[1h 1d 1w 1m 1q 1y]
      config
    end
  end
end
