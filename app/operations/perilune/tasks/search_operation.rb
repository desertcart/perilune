# frozen_string_literal: true

module Perilune
  module Tasks
    class SearchOperation < LedgerSync::Domains::Operation::Search
      def serializer_for(*)
        Perilune::Tasks::Serializer.new
      end
    end
  end
end
