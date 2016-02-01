module MetricCollector
  # FIXME: Once all collectors have been extracted, this class should not exist anymore
  class Base
    attr_reader :details

    def self.run_if_available(command)
      begin
        `#{command}`
      rescue SystemCallError
        nil
      end
    end

    def initialize(name, description, supported_metrics)
      @details = MetricCollector::Details.new(name: name, description: description, supported_metrics: supported_metrics)
      @wanted_metrics = {}
      @processing = nil
    end

    def collect_metrics(code_directory, wanted_metrics); raise NotImplementedError; end

    def self.available?; raise NotImplementedError; end

    def parse_supported_metrics(metrics_path, metric_collector_name, languages)
      supported_metrics = {}
      YAML.load_file(metrics_path)[:metrics].each do | key, value |
        if value[:type] == "NativeMetricSnapshot"
          supported_metrics[key] = KalibroClient::Entities::Miscellaneous::NativeMetric.new(value[:name], key, value[:scope], languages, metric_collector_name)
        else
          supported_metrics[key] = KalibroClient::Entities::Miscellaneous::HotspotMetric.new(value[:name], key, languages, metric_collector_name)
        end
      end
      supported_metrics
    end

    protected

    # FIXME: Once all collectors have been extracted, this class should not exist anymore
    # :nocov:
    def processing=(processing)
      @processing = processing
    end
    # :nocov:

    # FIXME: Once all collectors have been extracted, this class should not exist anymore
    # :nocov:
    def wanted_metrics=(wanted_metric_configurations)
      @wanted_metrics = {}
      wanted_metric_configurations.each do |metric_configuration|
        if self.details.supported_metrics.keys.include?(metric_configuration.metric.code)
          @wanted_metrics[metric_configuration.metric.code] = metric_configuration
        end
      end
    end
    # :nocov:

    # FIXME: Once all collectors have been extracted, this class should not exist anymore
    # :nocov:
    def wanted_metrics
      @wanted_metrics
    end
    # :nocov:

    # FIXME: Once all collectors have been extracted, this class should not exist anymore
    # :nocov:
    def processing
      @processing
    end
    # :nocov:
  end
end
