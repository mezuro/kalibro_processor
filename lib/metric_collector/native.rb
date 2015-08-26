require 'metric_collector/native/analizo'
require 'metric_collector/native/metric_fu'
require 'metric_collector/native/radon'

module MetricCollector
  module Native
    ALL = {"Analizo" => MetricCollector::Native::Analizo::Collector, "MetricFu" => MetricCollector::Native::MetricFu::Collector, "Radon" => MetricCollector::Native::Radon::Collector}

    def self.available
      ALL.select {|name, collector| collector.available?}
    end

    def self.details
      # This cache will represent a HUGE improvement for MetricCollectorsController response times
      Rails.cache.fetch("metric_collector/details", expires_in: 1.day) do
        @details = []

        available.each do |name, collector|
          collector_instance = collector.new
          @details << MetricCollector::Details.new(name: name,
                                                   description: collector_instance.details.description,
                                                   supported_metrics: collector_instance.details.supported_metrics)
        end
      end

      return @details
    end
  end
end
