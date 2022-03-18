# frozen_string_literal: true

module Perilune
  module Tasks
    module Mixin
      def self.included(base)
        base.include InstanceMethods
      end

      module InstanceMethods
        attr_reader :file, :task, :errors

        delegate :trace, to: :tracer

        def initialize(file:, task:)
          @file = file
          @task = task
        end

        def execute
          operate
        rescue StandardError => e
          failure(e.message)
        end

        def tags
          task.tags
        end

        def failure(message)
          @errors = message
        end

        def success?
          errors.blank?
        end

        def operate(*)
          raise StandardError, 'operate function is not defined'
        end

        def tracer_config
          @tracer_config ||= Trifle::Logger::Configuration.new
          @tracer_config.on(:wrapup) do |tracer|
            entry = Perilune::Task.find_by(id: tracer.reference)
            next if entry.nil?

            entry.update(
              tracer_data: tracer.data,
              state: tracer.state
            )
          end
          @tracer_config
        end

        def tracer
          @tracer ||= Trifle::Logger.tracer = Trifle::Logger::Tracer::Hash.new(
            key: task.id, reference: task.id, config: tracer_config
          )
        end

        def track_stats(event:, success:)
          Trifle::Stats.track(
            key: "perilune::#{event}", at: Time.zone.now,
            config: Trifle::Stat.mongo_config,
            values: {
              count: 1,
              success: success ? 1 : 0,
              failure: success ? 0 : 1
            }
          )
        end
      end
    end
  end
end
