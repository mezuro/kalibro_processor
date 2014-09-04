require 'metric_collector'

FactoryGirl.define do
  factory :base_metric_collector, class: MetricCollector::Base do
    name "Analizo"
    description "C/C++ and Java metrics"
    supported_metrics { [FactoryGirl.build(:analizo_native_metric)] }

    initialize_with { MetricCollector::Base.new(name, description, supported_metrics) }
  end
end