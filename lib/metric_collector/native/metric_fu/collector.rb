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

          begin
            runner.run
            MetricCollector::Native::MetricFu::Parser.parse_all(runner.yaml_path, wanted_metric_configurations, processing)
          ensure
            runner.clean_output
          end
        end

        def parse_supported_metrics
          super("#{Rails.root}/lib/metric_collector/native/metric_fu/metrics.yml", "MetricFu", [:RUBY])
        end

        def self.available?
          not self.run_if_available('metric_fu --version').nil?
        end
      end
    end
  end
end
