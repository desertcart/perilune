# frozen_string_literal: true

require 'rails_helper'
require_relative 'test_classes/success_class'
require_relative 'test_classes/failure_class'

RSpec.describe Perilune::Tasks::ExecutorJob do
  subject(:perform) { Perilune::Tasks::ExecutorJob.new.perform(task.id) }

  let(:task) { create(:task, task_klass: task_klass, task_type: task_type) }


  context "when the executor class is successful" do
    let(:task_klass) { 'SuccessClass' }
    let(:task_type) { 'Export' }

    it "sets processing_at timestamps" do
      perform
      task.reload
      expect(task.processing_at).not_to eq(nil)
    end

    it "tracks stats with success" do
      expect(Trifle::Stats).to receive(:track).with(hash_including(values: hash_including(export: hash_including(count: 1, duration: a_kind_of(Float)))))

      perform
    end
  end

  context "when the executor class fails" do
    let(:task_klass) { 'FailureClass' }
    let(:task_type) { 'Import' }

    before { allow_any_instance_of(FailureClass).to receive(:success?).and_return(false) }

    it "updates the task state to failed" do
      perform
      task.reload
      expect(task.state).to eq('failed')
    end

    it "tracks stats with failure" do
      expect(Trifle::Stats).to receive(:track).with(hash_including(values: hash_including(import: hash_including(count: 1, duration: a_kind_of(Float)))))
      perform
    end
  end

  context "when an exception occurs" do
    let(:task_klass) { 'UndefinedClass' }
    let(:task_type) { 'Import' }

    it "raises an error" do
      expect { perform }.to raise_error(Perilune::Tasks::ExecutorJob::UndefinedTask)
    end
  end

  context "when changing the default queue name" do
    it "sets the queue name as default" do
      expect(Perilune.default.queue_name).to eq(:default)
    end

    it "it sets the queue name with changed value" do
      Perilune.configure do |config|
        config.queue_name = 'perilune_queue'
      end
      expect(Perilune.default.queue_name).to eq('perilune_queue')
    end
  end
end
