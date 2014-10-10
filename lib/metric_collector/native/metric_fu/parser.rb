require 'metric_collector/native/metric_fu/parser/interface'
require 'metric_collector/native/metric_fu/parser/flog'

module MetricCollector
  module Native
    module MetricFu
      module Parser
        @parsers = { :flog => MetricCollector::Native::MetricFu::Parser::Flog }

        def self.parse_all(yaml_file_path, wanted_metric_configurations, processing)
          parsed_result = YAML.load_file(yaml_file_path)

          wanted_metric_configurations.each_key do |code|
            @parsers[code].parse(parsed_result[code], processing, wanted_metric_configurations[code])
          end
        end
      end
    end
  end
end
