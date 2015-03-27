module MetricCollector
  module Native
    module MetricFu
      class Collector < MetricCollector::Base
        def initialize
          description = YAML.load_file("#{Rails.root}/lib/metric_collector/native/descriptions.yml")["metric_fu"]
          super("MetricFu", description, parse_supported_metrics)
        end

        def collect_metrics(code_directory, wanted_metric_configurations, processing)
          self.wanted_metrics = wanted_metric_configurations
          runner = Runner.new(repository_path: code_directory)

          runner.run
          MetricCollector::Native::MetricFu::Parser.parse_all(runner.yaml_path, wanted_metric_configurations, processing)
          runner.clean_output
        end


        def parse_supported_metrics
          supported_metrics = {}
          YAML.load_file("#{Rails.root}/lib/metric_collector/native/metric_fu/metrics.yml")[:metrics].each do | key, value |
            supported_metrics[key] = KalibroClient::Entities::Miscellaneous::NativeMetric.new(value[:name], key, value[:scope], [:RUBY], "MetricFu")
          end
          supported_metrics
        end

        def self.available?
          not `metric_fu --version`.nil?
        end
      end
    end
  end
end
