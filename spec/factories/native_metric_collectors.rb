require 'metric_collector'

class NativeMetricCollector < MetricCollector::Base
  def initialize
    super('Native', 'Only for tests', [FactoryGirl.build(:analizo_native_metric)])
  end
end

FactoryGirl.define do
  factory :native_metric_collector do
  end
end