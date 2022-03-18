# frozen_string_literal: true

module Commodity
  module Trifle
    class Stat
      include Mongoid::Document

      field :key
      field :data
      index({ key: 1 })

      # custom Mongo configuration in addition to default config
      # config/initializers/trifle.rb
      def self.mongo_config
        client = Mongoid.client(:default)
        config = Trifle::Stats::Configuration.new
        config.driver = Trifle::Stats::Driver::Mongo.new(client)
        config.track_ranges = %i[hour day week month quarter year]
        config.time_zone = 'GMT'
        config.beginning_of_week = :monday

        config
      end
    end
  end
end
