# frozen_string_literal: true

module Perilune
  module HomeHelper
    def get_general_success_and_failure_series(type:, from:, to:)
      success_series = get_general_series_for(
        type: type, from: from,
        to: to, status: 'success'
      )

      failure_series = get_general_series_for(
        type: type, from: from,
        to: to, status: 'failure'
      )

      [success_series, failure_series]
    end

    private

    def get_general_series_for(type:, from:, to:, status:)
      series = Trifle::Stats.series(
        key: "perilune::#{type}::#{status}", from: from, to: to,
        granularity: '1h', skip_blanks: true
      )

      series.transpond.average(
        path: type, key: 'average_duration',
        sum: 'duration', count: 'count'
      )

      format_timeline_data(series, "#{type}.average_duration")
    end

    def format_timeline_data(series, path)
      series.format.timeline(path: path) do |at, value|
        {
          x: at.to_i * 1000,
          y: value.to_f
        }
      end.first
    end
  end
end
