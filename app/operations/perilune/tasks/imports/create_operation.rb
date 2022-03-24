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
            success(true)
          else
            failure(task.errors.full_messages)
          end
        end

        def task
          @task ||= Perilune::Task.new(
            state: 'draft',
            task_klass: params[:task_klass],
            task_type: 'Import',
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
      end
    end
  end
end
