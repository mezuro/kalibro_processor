module MetricCollector
  module Native
    module MetricFu
      module Parser
        class Flog < MetricCollector::Native::MetricFu::Parser::Interface
          def self.parse(flog_output, processing, metric_configuration)
            flog_output[:method_containers].each do |method_container|
              unless method_container[:path].blank?
                name_prefix = module_name_prefix(method_container[:path])
                method_container[:methods].each do |name, result|
                  value = result[:score]
                  name_suffix = module_name_suffix(name)
                  unless name_suffix.blank?
                    module_name = name_prefix + name_suffix
                    granularity = Granularity::METHOD
                    module_result = module_result(module_name, granularity, processing)
                    MetricResult.create(metric: metric_configuration.metric, value: value.to_f, module_result: module_result, metric_configuration_id: metric_configuration.id)
                  end
                end
              end
            end
          end

          private

          def self.module_name_prefix(file_name)
            # Generates a module name by removing the file extension, replacing slashes with dots, and internal dots with underscores
            without_extension = file_name.rpartition('.').first
            without_extension.gsub('.', '_').gsub('/', '.')
          end

          def self.module_name_suffix(module_name)
            return nil if module_name.end_with?("#none")
            return "." + module_name.gsub(/#|::/, ".")
          end

          def self.module_result(module_name, granularity, processing)
            kalibro_module = KalibroModule.new({long_name: module_name, granularity: granularity})
            module_result = ModuleResult.find_by_module_and_processing(kalibro_module, processing)

            if module_result.nil?
              kalibro_module.save
              ModuleResult.create(kalibro_module: kalibro_module, processing: processing)
            else
              module_result
            end
          end
        end
      end
    end
  end
end


