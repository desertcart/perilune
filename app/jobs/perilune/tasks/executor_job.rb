# frozen_string_literal: true

module Perilune
  module Tasks
    class ExecutorJob < ApplicationJob
      queue_as Perilune.default.queue_name

      class UndefinedTask < StandardError; end

      def perform(task_id)
        @task_id = task_id
        executor.execute
        executor.success? ? success : failure
      rescue StandardError => e
        failure
        tracer.trace("Exception: #{e.message}", state: :error) { e.backtrace }
        tracer.fail!
      ensure
        tracer.trace('Done.')
        tracer.wrapup
      end

      private

      def task
        @task ||= Perilune::Task.find(@task_id)
      end

      def success
        track_stats(success: true)
        task.update(state: 'processed')
      end

      def failure
        track_stats(success: false)
        task.update(state: 'failed', error_data: { executor_error: executor.errors })
      end

      def executor
        raise UndefinedTask unless Object.const_defined?(task.task_klass)

        @executor ||= task.task_klass.constantize.new(
          file: task.file.download, task: task, tracer: tracer
        )
      end

      def tracer_config # rubocop:disable Metrics/MethodLength
        @tracer_config ||= begin
          config = Trifle::Traces::Configuration.new
          config.on(:wrapup) do |tracer|
            entry = Perilune::Task.find_by(id: tracer.reference)
            next if entry.nil?

            entry.update(
              trace_data: tracer.data,
              trace_state: tracer.state
            )
          end
          config
        end
      end

      def tracer
        @tracer ||= Trifle::Traces.tracer = Trifle::Traces::Tracer::Hash.new(
          key: "Perilune::Task[#{task.id}]",
          reference: task.id, config: tracer_config
        )
      end

      def track_stats(success:)
        count_hash = success ? { count: 1, success: 1 } : { count: 1, failure: 1 }
        inner_hash = { task.task_klass.downcase.intern => count_hash }
        Trifle::Stats.track(
          key: "perilune::#{task.task_type.downcase}::#{task.task_klass.downcase}", at: Time.zone.now,
          config: Perilune.default.stats_driver_config,
          values: count_hash.merge(inner_hash)
        )
      end
    end
  end
end
