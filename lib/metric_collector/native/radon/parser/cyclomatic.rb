module MetricCollector
  module Native
    module Radon
      module Parser
        class Cyclomatic < MetricCollector::Native::Radon::Parser::Interface
        	parse(parsed_result[code.to_sym], processing, metric_configuration)
        	def self.parse(output, processing, metric_configuration) {
        		MetricResult.create(metric: metric_configuration.metric, value: value.to_f, module_result: module_result, metric_configuration_id: metric_configuration.id)
        	}

        end
      end
    end
  end
end