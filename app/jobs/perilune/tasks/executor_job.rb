# frozen_string_literal: true

module Perilune
  module Tasks
    class ExecutorJob < ApplicationJob
      queue_as :default

      class UndefinedTaskKlass < StandardError; end

      def perform(task_id)
        @task_id = task_id
        executor.execute
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

        @executor ||= task.task_klass.constantize.new(file: task.file.download, task:)
      end
    end
  end
end
