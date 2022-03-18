# frozen_string_literal: true

module Perilune
  module Tasks
    class FindOperation < LedgerSync::Domains::Operation::Find
      def serializer_for(*)
        Perilune::Tasks::Serializer.new
      end
    end
  end
end
