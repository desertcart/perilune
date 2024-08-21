# frozen_string_literal: true

module Perilune
  module Tasks
    class SearchOperation < LedgerSync::Domains::Operation::Search
      def serializer_for(*)
        Perilune::Tasks::Index::Serializer.new
      end

      private

      def operate
        if resources
          success
        else
          failure('Not found')
        end
      end

      def resources
        @resources ||= super.select(:id, :task_klass, :state, :tags, :created_at)
      end
    end
  end
end
