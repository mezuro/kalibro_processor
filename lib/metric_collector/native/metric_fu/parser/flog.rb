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
        end
      end
    end
  end
end


