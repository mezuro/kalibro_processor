require 'metric_collector/native/radon/parser/base'
require 'metric_collector/native/radon/parser/cyclomatic'
require 'metric_collector/native/radon/parser/maintainability'
require 'metric_collector/native/radon/parser/raw'

module MetricCollector
  module Native
    module Radon
      module Parser
        @parsers = {"cc" => MetricCollector::Native::Radon::Parser::Cyclomatic, 
          "mi" => MetricCollector::Native::Radon::Parser::Maintainability,
          "loc" => MetricCollector::Native::Radon::Parser::Raw,
          "lloc" => MetricCollector::Native::Radon::Parser::Raw,
          "sloc" => MetricCollector::Native::Radon::Parser::Raw,
          "comments" => MetricCollector::Native::Radon::Parser::Raw,
          "multi" => MetricCollector::Native::Radon::Parser::Raw,
          "blank" => MetricCollector::Native::Radon::Parser::Raw}

        def self.parse_all(file_path, wanted_metric_configurations, processing)
          wanted_metric_configurations.each do |metric_configuration|
            code = metric_configuration.metric.code
            @parsers[code].parse(file_path, processing, metric_configuration)
          end
        end

        def self.default_value_from(metric_code)
          @parsers[metric_code].default_value
        end

      end
    end
  end
end