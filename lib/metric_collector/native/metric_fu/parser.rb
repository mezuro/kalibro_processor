require 'metric_collector/native/metric_fu/parser/base'
require 'metric_collector/native/metric_fu/parser/flog'
require 'metric_collector/native/metric_fu/parser/saikuro'
require 'metric_collector/native/metric_fu/parser/flay'

module MetricCollector
  module Native
    module MetricFu
      module Parser
        @parsers = { 'flog' => MetricCollector::Native::MetricFu::Parser::Flog,
                     'saikuro' => MetricCollector::Native::MetricFu::Parser::Saikuro,
                     'flay' => MetricCollector::Native::MetricFu::Parser::Flay}

        def self.parse_all(yaml_file_path, wanted_metric_configurations, processing)
          parsed_result = YAML.load_file(yaml_file_path)

          wanted_metric_configurations.each do |metric_configuration|
            code = metric_configuration.metric.code.to_s
            @parsers[code].parse(parsed_result[code.to_sym], processing, metric_configuration)
          end
        end

        def self.default_value_from(metric_code)
          @parsers[metric_code.to_s].default_value
        end
      end
    end
  end
end
