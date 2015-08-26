module MetricCollector
  module Native
    module Radon
      module Parser
        class Raw < MetricCollector::Native::Radon::Parser::Base
          def self.command
            'raw'
          end

          def self.parse(raw_output, processing, metric_configuration)
            raw_output.each do |file_name, result_hash|
              module_name = module_name_prefix(file_name)
              value = result_hash[metric_configuration.metric.code] unless result_hash.key?('error')
              value ||= self.default_value

              module_result = module_result(module_name, KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE, processing)
              MetricResult.create(metric: metric_configuration.metric, value: value,
                                  module_result: module_result,
                                  metric_configuration_id: metric_configuration.id)
            end
          end

          def self.default_value
            0.0
          end
        end
      end
    end
  end
end
