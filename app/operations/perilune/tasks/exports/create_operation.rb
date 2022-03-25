# frozen_string_literal: true

module Perilune
  module Tasks
    module Exports
      class CreateOperation
        include LedgerSync::Domains::Operation::Mixin

        class Contract < LedgerSync::Ledgers::Contract
          params do
            required(:task_klass).filled(:string)
            required(:attrs).filled(:hash)
            optional(:tags).filled(:array)
          end
        end

        private

        def operate
          if task.save
            Perilune::Tasks::ExecutorJob.perform_later(task.id)
            success(true)
          else
            failure(task.errors.full_messages)
          end
        end

        def task
          @task ||= Perilune::Task.new(
            state: 'draft',
            task_klass: params[:task_klass],
            task_type: 'Export',
            attrs: params[:attrs],
            tags: params[:tags]
          )
        end

        # override to use common serializer for all domain
        def serializer_for(*)
          Perilune::Tasks::Serializer.new
        end
      end
    end
  end
end
