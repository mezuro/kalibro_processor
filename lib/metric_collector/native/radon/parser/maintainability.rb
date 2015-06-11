module MetricCollector
  module Native
    module Radon
      module Parser
        class Maintainability < MetricCollector::Native::Radon::Parser::Base
          def self.command
            'mi'
          end

          def self.parse(maintainability_output, processing = nil, metric_configuration = nil)

              maintainability_output.each do |file_name, result_hash|
                file_name = module_name_prefix(file_name)
                value =  result_hash["mi"]
                module_name = file_name
                granularity = Granularity::METHOD
                module_result = module_result(module_name, granularity, processing)
                MetricResult.create(metric: metric_configuration.metric, value: value.to_f, module_result: module_result, metric_configuration_id: metric_configuration.id)
              end
          end

          def self.default_value
            0.1
          end
          
        end
      end
    end
  end
end