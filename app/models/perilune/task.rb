# frozen_string_literal: true

module Perilune
  class Task < ApplicationRecord
    self.table_name = 'perilune_tasks'
    validates :state, inclusion: {
      in: %w[draft started processing processed failed],
      message: '%<value>s is not a valid state'
    }
    validates :task_klass, presence: true

    before_save :update_state_timestamp, if: :state_change_to_be_saved

    has_one_attached :file

    def file_name
      file.filename.to_s
    end

    def file_url
      file.url
    rescue StandardError
      nil
    end

    private

    def update_state_timestamp
      send("#{state}_at=", Time.now) if respond_to?("#{state}_at")
    end
  end
end
