# frozen_string_literal: true

module Perilune
  module HomeHelper

    def get_general_success_and_failure_series(type:, from:, to:)
      success_series = Trifle::Stats.series(key: "perilune::#{type}::success", from:, to:, range: :hour, skip_blanks: true)
      success_series.transpond.average(path: "#{type}", key: 'average_duration', sum: 'duration', count: 'count')
      success_series = format_timeline_data(success_series, "#{type}.average_duration")

      failure_series = Trifle::Stats.series(key: "perilune::#{type}::failure", from:, to:, range: :hour, skip_blanks: true)
      failure_series.transpond.average(path: "#{type}", key: 'average_duration', sum: 'duration', count: 'count')
      failure_series = format_timeline_data(failure_series, "#{type}.average_duration")

      [success_series, failure_series]
    end

    def format_timeline_data(series, path)
      series.format.timeline(path:) do |at, value|
        {
          x: at.to_i * 1000,
          y: value.to_f
        }
      end.first
    end
  end
end
