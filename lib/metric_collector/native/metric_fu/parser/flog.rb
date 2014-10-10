module MetricCollector
  module Native
    module MetricFu
      module Parser
        class Flog < MetricCollector::Native::MetricFu::Parser::Interface
          def self.parse(flog_output, processing)
            flog_output[:method_containers].each do |method_container|
              name_prefix = module_name_prefix(method_container[:path])
              method_container[:methods].each do |name, result|
                module_name = name_prefix << module_name_sufix(name)
                granularity = (module_name == name_prefix ? Granularity::CLASS : Granularity::METHOD)
              end
            end
            module_result(module_name, granularity, processing)
          end

          private

          def self.module_name_prefix(file_name)
            without_extension = file_name.split('.')[0].to_s
            without_extension.gsub('/', '.')
          end

          def self.module_name_sufix(module_name)
            sufix = module_name.gsub(/(#)|(::)/, ".").split('.')[-1]

            if sufix == "none"
              return ""
            else
              return sufix
            end
          end

          def module_result(module_name, granularity, processing)
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


