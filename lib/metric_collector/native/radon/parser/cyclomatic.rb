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
            self.pre_parse(collected_metrics_hash).each do |module_name, result, granularity|
              module_name = module_name + '.' + result['name']
              module_result = module_result(module_name, granularity, processing)
              value = result['complexity'].to_f
              TreeMetricResult.create(metric: metric_configuration.metric, value: value, module_result: module_result,
                                  metric_configuration_id: metric_configuration.id)
            end
          end

          private

          # This method checks for errors found by Radon, switch the valid results between METHOD and FUNCTION
          # Returning a Enumerator instance (a triples list) with [module_name, result, granularity]
          def self.pre_parse(collected_metrics_hash)
            Enumerator.new do |parsed_result|
              collected_metrics_hash.each do |file_name, results|
                next if has_error?(file_name, results) # If Radon couldn't parse the file we don't want to continue since the output is a error message

                file_module_name = module_name_prefix(file_name)

                results.each do |result|
                  if result['type'] == 'class'
                    granularity = KalibroClient::Entities::Miscellaneous::Granularity::METHOD
                    class_name = result['name']

                    result['methods'].each do |method|
                      parsed_result << ["#{file_module_name}.#{class_name}", method, granularity]
                    end
                  else
                    next if result['type'] == 'method' # These entries are duplicated on Radon's output
                    granularity = KalibroClient::Entities::Miscellaneous::Granularity::FUNCTION
                    parsed_result << [file_module_name, result, granularity]
                  end
                end
              end
            end
          end

          def self.has_error?(file_name, results)
            unless results.is_a?(Array)
              error = results['error'] if results.is_a?(Hash)
              error ||= 'Unknown error'
              Rails.logger.debug("Radon: error parsing file #{file_name}: #{error}") # This debug print has been kept in order that if there is some non-fatal error it does not get ignored

              true
            else
              false
            end
          end
        end
      end
    end
  end
end
