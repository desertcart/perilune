# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Perilune::Task, type: :model do
  let(:task) { create(:task) }
  let(:current_time) { Time.now }

  before do
    Timecop.freeze(current_time)
  end

  context "when setting state to uploaded" do
    it "set uploaded_at to current timestamp" do
      task.state = 'uploaded'
      task.save
      expect(task.uploaded_at).to eq(current_time)
    end
  end

  context "when setting state to processing" do
    it "set processing_at to current timestamp" do
      task.state = 'processing'
      task.save
      expect(task.processing_at).to eq(current_time)
    end
  end

  context "when setting state to processed" do
    it "set processed_at to current timestamp" do
      task.state = 'processed'
      task.save
      expect(task.processed_at).to eq(current_time)
    end
  end

  context "when setting state to failed" do
    it "set failed_at to current timestamp" do
      task.state = 'failed'
      task.save
      expect(task.failed_at).to eq(current_time)
    end
  end

  context "when setting state to draft" do
    it "doesn't raise any exception" do
      task.state = 'draft'
      expect { task.save! }.not_to raise_exception
    end
  end
end
