module MetricCollector
  class Base
    attr_reader :details

    def initialize(name, description, supported_metrics)
      @details = MetricCollector::Details.new(name: name, description: description, supported_metrics: supported_metrics)
      @wanted_metrics = {}
      @processing = nil
    end

    def collect_metrics(code_directory, wanted_metrics); raise NotImplementedError; end

    protected

    def processing=(processing)
      @processing = processing
    end

    def wanted_metrics=(wanted_metric_configurations)
      @wanted_metrics = {}
      wanted_metric_configurations.each do |metric_configuration|
        if self.details.supported_metrics.keys.include?(metric_configuration.metric.code)
          @wanted_metrics[metric_configuration.metric.code] = metric_configuration
        end
      end
    end

    def wanted_metrics
      @wanted_metrics
    end

    def processing
      @processing
    end
  end
end