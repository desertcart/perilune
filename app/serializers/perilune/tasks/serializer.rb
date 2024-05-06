# frozen_string_literal: true

module Perilune
  module Tasks
    class Serializer < LedgerSync::Domains::Serializer
      attribute :id
      attribute :task_klass
      attribute :task_type
      attribute :attrs
      attribute :state
      attribute :tags
      attribute :error_data
      attribute :created_at
      attribute :updated_at
      attribute :processing_at
      attribute :processed_at
      attribute :failed_at
      attribute :file_name
      attribute :file_url
      attribute :file_size do |attr|
        attr[:resource].file.try(:byte_size)
      end
      attribute :trace_state
      attribute :trace_data
    end
  end
end
