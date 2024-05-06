# frozen_string_literal: true

module Perilune
  module Tasks
    module Mixin
      def self.included(base)
        base.include InstanceMethods
      end

      module InstanceMethods
        attr_reader :file, :task, :tracer, :errors

        delegate :trace, to: :tracer

        def initialize(file:, task:, tracer:)
          @file = file
          @task = task
          @tracer = tracer
        end

        def execute
          task.update(state: 'processing')
          operate
        rescue StandardError => e
          failure(e.message)
          raise e
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
      end
    end
  end
end
