# frozen_string_literal: true

require 'perilune/engine'
require 'perilune/tasks/mixin'
require 'perilune/configuration'

module Perilune
  # Your code goes here...
  def self.default
    @default ||= Configuration.new
  end

  def self.configure
    yield(default)

    default
  end
end
