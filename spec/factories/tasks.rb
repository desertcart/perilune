FactoryBot.define do
  factory :task, class: 'Perilune::Task' do
    task_klass { "Test" }
    state { "draft" }
  end
end