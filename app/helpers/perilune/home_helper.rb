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
        granularity: '1h', skip_blanks: true, config: Perilune.default.stats_driver_config
      )

      format_timeline_data(series, type)
    end

    def format_timeline_data(series, type)
      count_path = "#{type}.count"
      counts = series.format.timeline(path: count_path).fetch(count_path, []).to_h
      duration_path = "#{type}.duration"
      series.format.timeline(path: duration_path) do |at, duration|
        count = counts.fetch(at, 0)
        { x: at.to_i * 1000, y: count.positive? ? duration.to_f / count : 0.0 }
      end.fetch(duration_path, [])
    end
  end
end
