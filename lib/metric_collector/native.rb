require 'metric_collector/native/analizo'
require 'metric_collector/native/metric_fu'

module MetricCollector
  module Native
    ALL = {"Analizo" => MetricCollector::Native::Analizo::Collector, "MetricFu" => MetricCollector::Native::MetricFu::Collector}

    def self.available
      ALL.select {|name, collector| collector.available?}
    end

    def self.details
      details = []

      available.each do |name, collector|
        collector_instance = collector.new
        details << MetricCollector::Details.new(name: name,
                                                description: collector_instance.details.description,
                                                supported_metrics: collector_instance.details.supported_metrics)
      end

      return details
    end
  end
end
