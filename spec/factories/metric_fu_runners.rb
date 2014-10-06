require 'metric_collector'

FactoryGirl.define do
  factory :metric_fu_runner, class: MetricCollector::Native::MetricFu::Runner do
    repository_path { Dir.pwd }

    initialize_with { MetricCollector::Native::MetricFu::Runner.new(repository_path: repository_path) }
  end
end