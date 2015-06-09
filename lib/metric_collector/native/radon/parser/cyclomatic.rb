module MetricCollector
  module Native
    module Radon
      module Parser
        class Cyclomatic < MetricCollector::Native::Radon::Parser::Base

          def self.parse(cyclomatic_output, processing = nil, metric_configuration = nil)

            cyclomatic_output.each do |file_name, result_hash|
              name_prefix = module_name_prefix(file_name)
              result_hash.each do |key|
                name_suffix = module_name_suffix(key['name'])
                value = key['complexity']
                module_name = name_prefix + name_suffix
                granularity = Granularity::METHOD
                module_result = module_result(module_name, granularity, processing)
                MetricResult.create(metric: metric_configuration.metric, value: value.to_f, module_result: module_result, metric_configuration_id: metric_configuration.id)
              end
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