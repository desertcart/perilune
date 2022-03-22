# frozen_string_literal: true

module Perilune
  module Tasks
    module Imports
      class CreateOperation
        include LedgerSync::Domains::Operation::Mixin

        class Contract < LedgerSync::Ledgers::Contract
          params do
            required(:file).maybe(type?: File)
            required(:file).maybe(type?: Tempfile)
            required(:task_klass).filled(:string)
            optional(:tags).filled(:array)
          end
        end

        private

        def operate
          attach!
          if task.save
            Perilune::Tasks::ExecutorJob.perform_later(task.id)
            track_stats(event: 'Imports', success: true)
            success(true)
          else
            track_stats(event: 'Imports', success: false)
            failure(task.errors.full_messages)
          end
        end

        def task
          @task ||= Perilune::Task.new(
            state: 'draft',
            task_klass: params[:task_klass],
            tags: params[:tags]
          )
        end

        def attach!
          task.file.attach(
            io: params[:file],
            key: "perilune/#{ActiveStorage::Blob.generate_unique_secure_token}",
            filename: "#{params[:task_klass]}_#{Time.zone.now.to_i}"
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
