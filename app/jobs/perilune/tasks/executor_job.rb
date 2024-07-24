# frozen_string_literal: true

require 'benchmark'

module Perilune
  module Tasks
    class ExecutorJob < ApplicationJob
      queue_as Perilune.default.queue_name

      class UndefinedTask < StandardError; end

      def perform(task_id)
        @task_id = task_id

        @duration = Benchmark.realtime do
          executor.execute
        end

        executor.success? ? success : failure
      rescue StandardError => e
        crash(e)
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

      def crash(error)
        failure
        tracer.trace("Exception: #{error.message}", state: :error) { error.backtrace }
        tracer.fail!
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
        task_type = task.task_type.downcase == 'import' ? 'import' : 'export'
        state = success ? 'success' : 'failure'

        Trifle::Stats.track(
          key: "perilune::#{task_type}::#{state}",
          at: Time.zone.now,
          config: Perilune.default.stats_driver_config,
          values: trifle_values_hash(success:, task_type:)
        )
      end

      def duration_to_ms
        return 0 unless @duration.present? && !@duration.zero?

        (@duration * 1000).round
      end

      def trifle_values_hash(success:, task_type:)
        @duration = @duration ? @duration * 1000 : 0

        {
          task_type.to_sym => {
            count: 1,
            duration: duration_to_ms
          }
        }
      end
    end
  end
end
