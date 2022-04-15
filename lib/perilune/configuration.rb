# frozen_string_literal: true

module Perilune
  class Configuration
    attr_accessor :queue_name

    def initialize
      @queue_name = queue_name || 'default'
    end
  end
end
