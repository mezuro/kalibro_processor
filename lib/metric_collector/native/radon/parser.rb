require 'metric_collector/native/radon/parser/base'
require 'metric_collector/native/radon/parser/cyclomatic'
require 'metric_collector/native/radon/parser/maintainability'
require 'metric_collector/native/radon/parser/raw'

module MetricCollector
  module Native
    module Radon
      module Parser
        @parsers = {"cc" => MetricCollector::Native::Radon::Parser::Cyclomatic, 
          "raw" => MetricCollector::Native::Radon::Parser::Raw, 
          "mi" => MetricCollector::Native::Radon::Parser::Maintainability}

        def parse_all(yaml_file_path, wanted_metric_configurations, processing)
          parsed_result = YAML.load_file(yaml_file_path)

          wanted_metric_configurations.each do |metric_configuration|
            code = metric_configuration.metric.code
            @parsers[code].parse(parsed_result[code.to_sym], processing, metric_configuration)
          end
        end
      end
    end
  end
end