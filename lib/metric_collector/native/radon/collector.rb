module MetricCollector
  module Native
    module Radon
      class Collector < MetricCollector::Base
        def initialize
          description = YAML.load_file("#{Rails.root}/lib/metric_collector/native/descriptions.yml")["radon"]
          super("Radon", description, parse_supported_metrics)
        end

        def collect_metrics(code_directory, wanted_metric_configurations, processing)
          self.wanted_metrics = wanted_metric_configurations
          runner = Runner.new(repository_path: code_directory, wanted_metric_configurations: wanted_metric_configurations)

          begin
            runner.run_wanted_metrics
            MetricCollector::Native::Radon::Parser.parse_all(code_directory, wanted_metric_configurations, processing)
          ensure
            runner.clean_output
          end
        end

        def self.available?
          ! self.run_if_available('radon --version').nil?
        end

        def parse_supported_metrics
          supported_metrics = {}
          YAML.load_file("#{Rails.root}/lib/metric_collector/native/radon/metrics.yml")[:metrics].each do | code, details |
            supported_metrics[code] = KalibroClient::Entities::Miscellaneous::NativeMetric.new(details[:name], code, details[:scope], [:PYTHON], "Radon")
          end
          supported_metrics
        end
      end
    end
  end
end
