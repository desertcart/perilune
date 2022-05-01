# frozen_string_literal: true

module Perilune
  module Tasks
    class ExecutorJob < ApplicationJob
      queue_as Perilune.default.queue_name

      class UndefinedTaskKlass < StandardError; end

      def perform(task_id)
        @task_id = task_id
        executor.execute
        track_stats(event: task.task_type, success: executor.success?)
        executor.success? ? success : failure
      end

      private

      def task
        @task ||= Perilune::Task.find(@task_id)
      end

      def success
        task.update(state: 'processed')
      end

      def failure
        task.update(state: 'failed', error_data: { executor_error: executor.errors })
      end

      def executor
        raise UndefinedTaskKlass unless Object.const_defined?(task.task_klass)

        @executor ||= task.task_klass.constantize.new(file: task.file.download, task: task)
      end

      def track_stats(event:, success:)
        count_hash = success ? { count: 1, success: 1 } : { count: 1, failure: 1 }
        inner_hash = { event.downcase.intern => count_hash }
        Trifle::Stats.track(
          key: "perilune::#{event.downcase}", at: Time.zone.now,
          config: Perilune.default.stats_driver_config,
          values: count_hash.merge(inner_hash)
        )
      end
    end
  end
end
