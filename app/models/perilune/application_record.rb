# frozen_string_literal: true

module Perilune
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
