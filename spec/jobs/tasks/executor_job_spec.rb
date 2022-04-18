# frozen_string_literal: true

require 'rails_helper'
require_relative 'test_classes/success_class'

RSpec.describe Perilune::Tasks::ExecutorJob do
  subject(:perform) { Perilune::Tasks::ExecutorJob.new.perform(task.id) }


  context "when there is no issue in the executor class" do
    let(:task) { create(:task, task_klass: 'SuccessClass') }

    it "sets processing_at timestamps" do
      perform
      task.reload
      expect(task.processing_at).not_to eq(nil)
    end
  end

  context "change the default queue name" do

    it "sets default queue name as default" do
      expect(Perilune.default.queue_name).to eq('default')
    end

    it "sets default queue name as perilune_queue" do
      Perilune.configure do |config|
        config.queue_name = 'perilune_queue'
      end
      expect(Perilune.default.queue_name).to eq('perilune_queue')
    end
  end
end
