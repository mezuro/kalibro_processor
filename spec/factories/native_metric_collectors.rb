require 'metric_collector'

class NativeMetricCollector < MetricCollector::Base
  def initialize
    metrics = [FactoryGirl.build(:native_metric, metric_collector_name: 'NativeMetricCollector')]
    super('Native', 'Only for tests', metrics)
  end
end

FactoryGirl.define do
  factory :native_metric_collector do
  end
end
