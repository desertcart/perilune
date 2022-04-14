# frozen_string_literal: true

class CreatePeriluneTask < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :perilune_tasks do |t|
      t.string :task_klass
      t.jsonb :attrs
      t.string :state
      t.text :tags, array: true, default: []
      t.jsonb :error_data
      t.string :task_type
      t.datetime :processing_at
      t.datetime :processed_at
      t.datetime :failed_at
      t.timestamps
    end
  end
end
