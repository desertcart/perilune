# frozen_string_literal: true

module Perilune
  class Configuration
    attr_accessor :queue_name, :trifle_stat_driver, :trifle_stat_track_ranges,
                  :trifle_stat_time_zone, :trifle_stat_beginning_of_week

    def initialize
      @queue_name = :default
      @trifle_stat_driver = ::Trifle::Stats::Driver::Redis.new
      @trifle_stat_track_ranges = %i[hour day week month quarter year]
      @trifle_stat_time_zone = 'GMT'
      @trifle_stat_beginning_of_week = :monday
    end
  end
end
