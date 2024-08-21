# frozen_string_literal: true

module Perilune
  module Tasks
    module Index
      class Serializer < LedgerSync::Domains::Serializer
        attribute :id
        attribute :task_klass
        attribute :state
        attribute :tags
        attribute :created_at
      end
    end
  end
end
