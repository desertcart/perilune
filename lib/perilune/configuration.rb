# frozen_string_literal: true

module Perilune
  class Configuration
    def queue_name
      :default
    end

    def stats_driver_config
      config = ::Trifle::Stats::Configuration.new
      config.driver = ::Trifle::Stats::Driver::Redis.new
      config
    end
  end
end
