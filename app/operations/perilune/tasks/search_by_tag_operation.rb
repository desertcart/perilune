# frozen_string_literal: true

module Perilune
  module Tasks
    class SearchByTagOperation < Perilune::Tasks::SearchOperation
      class Contract < LedgerSync::Ledgers::Contract
        params do
          required(:tag).value(:string)
          required(:query).value(:hash)
          required(:limit).value(:hash)
          required(:includes).value(:array)
          required(:order).value(:string)
          required(:page).value(:integer)
          required(:per).value(:integer)
        end
      end

      def resources
        @resources ||= super.where('? = ANY (tags)', params[:tag])
      end

      def serializer_for(*)
        Perilune::Tasks::Serializer.new
      end
    end
  end
end
