module MetricCollector
  module Native
    module Radon
      module Parser
        class Cyclomatic < MetricCollector::Native::Radon::Parser::Base
          def self.command
            'cc'
          end

          def self.default_value
            1.0
          end

          def self.parse(collected_metrics_hash, processing, metric_configuration)
            self.methods(collected_metrics_hash).each do |module_name, method|
              module_name = module_name + '.' + method['name']
              module_result = module_result(module_name, Granularity::METHOD, processing)
              value = extract_value(method)
              MetricResult.create(metric: metric_configuration.metric, value: value, module_result: module_result,
                                  metric_configuration_id: metric_configuration.id)
            end
          end

          private

          def self.methods(collected_metrics_hash)
            Enumerator.new do |y|
              collected_metrics_hash.each do |file_name, results|
                unless results.is_a?(Array)
                  error = results['error'] if results.is_a?(Hash)
                  error ||= 'Unknown error'
                  Rails.logger.debug("Radon: error parsing file #{file_name}: #{error}")

                  next
                end

                file_module_name = module_name_prefix(file_name)

                results.each do |result|
                  byebug unless result.is_a?(Hash)
                  if result['type'] == 'class'
                    class_name = result['name']

                    result['methods'].each do |method|
                      y << ["#{file_module_name}.#{class_name}", method]
                    end
                  else
                    module_name = if result['type'] == 'method'
                      "#{file_module_name}.#{result['classname']}"
                    elsif result['type'] == 'function'
                      file_module_name
                    end

                    y << [module_name, result]
                  end
                end
              end
            end
          end

          def self.extract_value(method_metrics_hash)
            method_metrics_hash['complexity'].to_f
          end
        end
      end
    end
  end
end
