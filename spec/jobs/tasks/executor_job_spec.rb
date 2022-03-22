# frozen_string_literal: true

require 'rails_helper'
require_relative 'test_classes/success_class'

RSpec.describe Perilune::Tasks::ExecutorJob do
  subject(:perform) { Perilune::Tasks::ExecutorJob.new.perform(task.id) }


  context "when no issue in the executor class" do
    let(:task) { create(:task, task_klass: 'SuccessClass') }

    it "sets processing_at timestamps" do
      perform
      task.reload
      expect(task.processing_at).not_to eq(nil)
    end
  end
end
