module MetricCollector
  module Native
    module Radon
      class Runner
        def initialize(attributes={repository_path: nil, wanted_metric_configurations: {}})
          @repository_path = attributes[:repository_path]
          @wanted_metric_configurations = attributes[:wanted_metric_configurations]

          @runners = {"cc" => MetricCollector::Native::Radon::MetricRunners::Cyclomatic, 
          "raw" => MetricCollector::Native::Radon::MetricRunners::Raw, 
          "mi" => MetricCollector::Native::Radon::MetricRunners::Maintainability}
        end

        def repository_path
          @repository_path
        end

        def run_wanted_metrics
          @wanted_metric_configurations.each do |metric_configuration|
            code = metric_configuration.metric.code
            @runners[code].run(@repository_path)
          end
        end

        def clean_output
          @wanted_metric_configurations.each do |metric_configuration|
            code = metric_configuration.metric.code
            @runners[code].clean_output
          end
        end
      end
    end
  end
end