# frozen_string_literal: true

require 'perilune/engine'
require 'perilune/tasks/mixin'
require 'perilune/configuration'

module Perilune
  FACTORY_PATH = File.expand_path('../spec/factories', __dir__)

  def self.default
    @default ||= Configuration.new
  end

  def self.configure
    yield(default)

    default
  end
end
