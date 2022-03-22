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
            track_stats(event: 'Exports', success: true)
            success(true)
          else
            track_stats(event: 'Exports', success: true)
            failure(task.errors.full_messages)
          end
        end

        def task
          @task ||= Perilune::Task.new(
            state: 'draft',
            task_klass: params[:task_klass],
            attrs: params[:attrs],
            tags: params[:tags]
          )
        end

        # override to use common serializer for all domain
        def serializer_for(*)
          Perilune::Tasks::Serializer.new
        end

        def track_stats(event:, success:)
          Trifle::Stats.track(
            key: "Perilune::#{event}", at: Time.zone.now,
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
