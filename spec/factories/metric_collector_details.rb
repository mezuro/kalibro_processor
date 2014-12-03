require 'metric_collector'

FactoryGirl.define do
  factory :metric_collector_details, class: MetricCollector::Details do
    name "Analizo"
    description "C/C++ and Java metrics"
    supported_metrics { [FactoryGirl.build(:analizo_native_metric)] }

    initialize_with { MetricCollector::Details.new({name: name, description: description, supported_metrics: supported_metrics}) }
  end
end

