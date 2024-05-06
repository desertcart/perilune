# frozen_string_literal: true

module Perilune
  module ApplicationHelper
    def task_state(task) # rubocop:disable Metrics/MethodLength
      return unless task.state

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

    def trace_state(task) # rubocop:disable Metrics/MethodLength
      return unless task.trace_state

      case task.trace_state.to_sym
      when :running
        content_tag(:div, task.trace_state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-blue-500 text-blue-50') # rubocop:disable Layout/LineLength
      when :error
        content_tag(:div, task.trace_state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-red-500 text-red-50') # rubocop:disable Layout/LineLength
      when :warning
        content_tag(:div, task.trace_state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-yellow-500 text-yellow-50') # rubocop:disable Layout/LineLength
      when :success
        content_tag(:div, task.trace_state,
                    class: 'inline-flex items-center px-2.5 py-0.5 rounded-sm text-sm font-medium uppercase bg-green-500 text-green-50') # rubocop:disable Layout/LineLength
      end
    end
  end
end
