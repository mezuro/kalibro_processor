module MetricCollector
  module Native
    module Radon
      module Parser
        class Raw < MetricCollector::Native::Radon::Parser::Base

        	def self.parse(raw_output, processing = nil, metric_configuration = nil)
            raw_output.each do |file_name, result_hash|
                file_name = module_name_prefix(file_name)
                value =  result_hash[metric_configuration.metric.code]
                module_name = file_name
                granularity = Granularity::METHOD
                module_result = module_result(module_name, granularity, processing)
                MetricResult.create(metric: metric_configuration.metric, value: value.to_f, module_result: module_result, metric_configuration_id: metric_configuration.id)
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