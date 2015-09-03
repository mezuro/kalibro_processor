module MetricCollector
  module Native
    module Radon
      module Parser
        class Maintainability < MetricCollector::Native::Radon::Parser::Base
          def self.command
            'mi'
          end

          def self.parse(maintainability_output, processing, metric_configuration)
            maintainability_output.each do |file_name, result_hash|
              module_name = module_name_prefix(file_name)
              value = result_hash['mi'] unless result_hash.key?('error')
              value ||= self.default_value

              module_result = module_result(module_name, KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE, processing)
              TreeMetricResult.create(metric: metric_configuration.metric, value: value,
                                  module_result: module_result,
                                  metric_configuration_id: metric_configuration.id)
            end
          end

          def self.default_value
            100.0
          end
        end
      end
    end
  end
end
