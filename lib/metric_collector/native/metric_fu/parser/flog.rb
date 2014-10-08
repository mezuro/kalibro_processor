module MetricCollector
  module Native
    module MetricFu
      module Parser
        class Flog < MetricCollector::Native::MetricFu::Parser::Interface
          def self.parse(flog_output)
            flog_output[:method_containers].each do |method_container|
              name_prefix = module_name_prefix(method_container[:path])
              method_container[:methods].each do |name, result|
                module_name = name_prefix << module_name_sufix(name)
                granularity = (module_name == name_prefix ? Granularity::CLASS : Granularity::METHOD)
              end
            end
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
        end
      end
    end
  end
end


