# frozen_string_literal: true

module Perilune
  module ApplicationHelper
    def task_state(task) # rubocop:disable Metrics/MethodLength
      case task.state.to_sym
      when :draft
        content_tag(:div, task.state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-gray-500 text-gray-50') # rubocop:disable Layout/LineLength
      when :uploaded
        content_tag(:div, task.state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-yellow-500 text-yellow-50') # rubocop:disable Layout/LineLength
      when :processed
        content_tag(:div, task.state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-blue-500 text-blue-50') # rubocop:disable Layout/LineLength
      when :failed
        content_tag(:div, task.state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-red-500 text-red-50') # rubocop:disable Layout/LineLength
      end
    end
  end
end
