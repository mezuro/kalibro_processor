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
            self.results_enumerator(collected_metrics_hash).each do |module_name, result, granularity|
              module_name = module_name + '.' + result['name']
              module_result = module_result(module_name, granularity, processing)
              value = result['complexity'].to_f
              MetricResult.create(metric: metric_configuration.metric, value: value, module_result: module_result,
                                  metric_configuration_id: metric_configuration.id)
            end
          end

          private

          def self.results_enumerator(collected_metrics_hash)
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
                  if result['type'] == 'class'
                    granularity = KalibroClient::Entities::Miscellaneous::Granularity::METHOD
                    class_name = result['name']

                    result['methods'].each do |method|
                      y << ["#{file_module_name}.#{class_name}", method, granularity]
                    end
                  else
                    if result['type'] == 'method'
                      next
                    end
                    granularity = KalibroClient::Entities::Miscellaneous::Granularity::FUNCTION
                    y << [file_module_name, result, granularity]
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
