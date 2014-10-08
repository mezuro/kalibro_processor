require 'metric_collector/native/metric_fu/parser/interface'
require 'metric_collector/native/metric_fu/parser/flog'

module MetricCollector
  module Native
    module MetricFu
      module Parser
        @parsers = { :flog => MetricCollector::Native::MetricFu::Parser::Flog }

        def self.collected_results(yaml_file_path, wanted_metrics)
          parsed_result = YAML.load_file(yaml_file_path)

          wanted_metrics.each do |metric|
            @parsers[metric].parse(parsed_result[metric])
          end
        end
      end
    end
  end
end