module MetricCollector
  module Native
    module Radon
      module Parser
        class Base
          def self.parse(collected_metrics_hash, processing, metric_configuration)
            raise NotImplementedError
          end

          # Sometimes the parser does not generate results for some Module that
          # other may generate. In this we case need a default value to fulfill
          # it.
          def self.default_value; raise NotImplementedError; end

          private

          def self.module_name_prefix(file_name)
            # Generates a module name by removing the file extension, replacing slashes with dots, and internal dots with underscores
            without_extension = file_name.rpartition('.').first
            without_extension.gsub('.', '_').gsub('/', '.')
          end

          def self.module_result(module_name, granularity, processing)
            kalibro_module = KalibroModule.new({long_name: module_name, granularity: granularity})
            module_result = ModuleResult.find_by_module_and_processing(kalibro_module, processing)

            if module_result.nil?
              module_result = ModuleResult.create(processing: processing)
              kalibro_module.module_result = module_result
              kalibro_module.save!
              module_result.update(kalibro_module: kalibro_module)
            end
            return module_result
          end
        end
      end
    end
  end
end
