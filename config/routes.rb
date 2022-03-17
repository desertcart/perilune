# frozen_string_literal: true

Perilune::Engine.routes.draw do
  root to: 'home#index'
  resources :tasks, only: %i[index show]
end
