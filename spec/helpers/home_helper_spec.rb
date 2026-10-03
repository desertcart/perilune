# frozen_string_literal: true

require 'spec_helper'
require 'logger'
require 'rails'
require 'redis'
require 'trifle/stats'
require 'perilune'
require_relative '../../app/helpers/perilune/home_helper'

RSpec.describe Perilune::HomeHelper do
  let(:helper) { Object.new.extend(described_class) }
  let(:at) { Time.utc(2026, 10, 3, 8) }

  around do |example|
    previous_driver = Perilune.default.stats_driver
    previous_global_buffer_enabled = Trifle::Stats.default.buffer_enabled
    previous_global_driver = begin
      Trifle::Stats.default.driver
    rescue Trifle::Stats::DriverNotFound
      nil
    end
    Perilune.default.stats_driver = Trifle::Stats::Driver::Process.new
    Trifle::Stats.default.driver = Trifle::Stats::Driver::Process.new
    Trifle::Stats.default.buffer_enabled = false
    example.run
  ensure
    Perilune.default.stats_driver = previous_driver
    Trifle::Stats.default.driver = previous_global_driver
    Trifle::Stats.default.buffer_enabled = previous_global_buffer_enabled
  end

  def track(type:, status:, duration:, count: 1, time: at, config: Perilune.default.stats_driver_config)
    Trifle::Stats.track(
      key: "perilune::#{type}::#{status}", at: time, config: config,
      values: { type => { count: count, duration: duration } }
    )
  end

  def chart(type:)
    helper.get_general_success_and_failure_series(type: type, from: at - 3600, to: at + 3600)
  end

  it 'averages task durations in the configured Perilune store and returns chart points' do
    track(type: 'import', status: 'success', duration: 200)
    track(type: 'import', status: 'success', duration: 600)
    track(type: 'import', status: 'failure', duration: 900)
    track(type: 'import', status: 'success', duration: 9999, config: Trifle::Stats.default)

    expect(chart(type: 'import')).to eq([
      [{ x: at.to_i * 1000, y: 400.0 }],
      [{ x: at.to_i * 1000, y: 900.0 }]
    ])
  end

  it 'queries export metrics independently' do
    track(type: 'import', status: 'success', duration: 9999)
    track(type: 'export', status: 'success', duration: 1200, count: 3)
    expect(chart(type: 'export')).to eq([[{ x: at.to_i * 1000, y: 400.0 }], []])
  end

  it 'returns empty arrays when no tasks have run' do
    expect(chart(type: 'import')).to eq([[], []])
    expect(chart(type: 'export')).to eq([[], []])
  end

  it 'keeps averages finite when a bucket has a zero count' do
    track(type: 'import', status: 'success', duration: 100, count: 0)
    expect(chart(type: 'import')).to eq([[{ x: at.to_i * 1000, y: 0.0 }], []])
  end

  it 'matches each hourly duration sum with its task count' do
    track(type: 'import', status: 'success', duration: 100)
    track(type: 'import', status: 'success', duration: 900, count: 3, time: at + 3600)
    expect(chart(type: 'import')).to eq([
      [{ x: at.to_i * 1000, y: 100.0 }, { x: (at.to_i + 3600) * 1000, y: 300.0 }], []
    ])
  end
end
