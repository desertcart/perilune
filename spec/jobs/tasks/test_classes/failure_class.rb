# frozen_string_literal: true

class FailureClass
  include Perilune::Tasks::Mixin

  def operate
    false
  end
end
