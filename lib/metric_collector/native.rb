require 'metric_collector/native/analizo'

module MetricCollector
  module Native
    ALL = {"Analizo" => MetricCollector::Native::Analizo}

    def self.available
      ALL.select {|name, collector| collector.available?}
    end

    def self.details
      details = []

      available.each do |name, collector|
        collector_instance = collector.new
        details << MetricCollector::Details.new(name: name,
                                                description: collector_instance.description,
                                                supported_metrics: collector_instance.supported_metrics)
      end

      return details
    end
  end
end