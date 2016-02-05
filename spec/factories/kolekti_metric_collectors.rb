require 'metric_collector'

class KolektiMetricCollector < Kolekti::Collector
  def initialize
    metrics = [FactoryGirl.build(:native_metric, metric_collector_name: 'NativeMetricCollector')]
    super('KolektiMetricCollector', 'This is a dummy MetricCollector for tests purposes', metrics)
  end
end

FactoryGirl.define do
  factory :kolekti_metric_collector do
  end
end