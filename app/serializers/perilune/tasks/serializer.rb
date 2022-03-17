# frozen_string_literal: true

module Perilune
  module Tasks
    class Serializer < LedgerSync::Domains::Serializer
      attribute :id
      attribute :task_klass
      attribute :attrs
      attribute :state
      attribute :tags
      attribute :error_data
      attribute :created_at
      attribute :updated_at
      attribute :file_name
      attribute :file_url
    end
  end
end
