require 'metric_collector/native/metric_fu/runner'
require 'metric_collector/native/metric_fu/collector'
require 'metric_collector/native/metric_fu/parser'

module MetricCollector
  module Native
    module MetricFu

      def self.available?
        not `metric_fu --version`.nil?
      end
    end
  end
end
