# frozen_string_literal: true

module Perilune
  class Engine < ::Rails::Engine
    isolate_namespace Perilune

    initializer "perilune.assets.precompile" do |app|
      app.config.assets.precompile += %w( perilune.js perilune_css.js perilune_css.css )
    end
  end
end
