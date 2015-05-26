module MetricCollector
  module Native
    module Radon
      module Parser
        class Cyclomatic < MetricCollector::Native::Radon::Parser::Base

        def self.parse(output_path)
    		data_hash = JSON.parse(output_path)
    		#value = data_hash[:score]

    		#MetricResult.create(metric: metric_configuration.metric, value: value.to_f, module_result: module_result, metric_configuration_id: metric_configuration.id)
        end

          def self.default_value
            0.0
          end

        end
      end
    end
  end
end