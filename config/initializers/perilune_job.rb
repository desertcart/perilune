# frozen_string_literal: true

class PeriluneJob
  # custom ActiveJob configuration
  def self.default_queue
    :perilune_job
  end
end
