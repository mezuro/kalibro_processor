require 'metric_collector'

FactoryGirl.define do
  factory :base_metric_collector, class: MetricCollector::Base do
    details { FactoryGirl.build(:metric_collector_details) }

    initialize_with { MetricCollector::Base.new(details.name, details.description, details.supported_metrics) }
  end
end