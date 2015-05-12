module MetricCollector
  module Native
    module MetricFu
      module Parser
        class Saikuro < MetricCollector::Native::MetricFu::Parser::Interface
          def self.parse(saikuro_output, processing, metric_configuration)
            saikuro_output[:files].each do |file|
              name_prefix = module_name_prefix(file[:filename])
              file[:classes].each do |clazz|
                clazz[:methods].each do |method|
                  value = method[:complexity]
                  name_suffix = module_name_suffix(method[:name])
                  module_name = name_prefix + name_suffix
                  granularity = Granularity::METHOD
                  module_result = module_result(module_name, granularity, processing)
                  MetricResult.create(metric: metric_configuration.metric, value: value.to_f, module_result: module_result, metric_configuration_id: metric_configuration.id)
                end
              end
            end
          end
        end
      end
    end
  end
end

