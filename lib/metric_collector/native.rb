require 'metric_collector/native/analizo'

module MetricCollector
  module Native
    ALL = {"Analizo" => MetricCollector::Native::Analizo}

    def self.available
      ALL.select {|name, collector| collector.available?}
    end
  end
end