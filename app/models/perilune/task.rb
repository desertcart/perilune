# frozen_string_literal: true

module Perilune
  class Task < ApplicationRecord
    self.table_name = 'perilune_tasks'
    validates :state, inclusion: {
      in: %w[draft started processed failed],
      message: '%<value>s is not a valid state'
    }
    validates :task_klass, presence: true
    has_one_attached :file

    def file_name
      file.filename.to_s
    end

    def file_url
      file.url
    rescue StandardError
      nil
    end
  end
end
