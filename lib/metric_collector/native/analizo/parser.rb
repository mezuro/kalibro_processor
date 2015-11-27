module MetricCollector
  module Native
    module Analizo
      class Parser
        attr_accessor :processing, :wanted_metrics

        def initialize(processing: nil, wanted_metrics: [])
          self.processing = processing
          self.wanted_metrics = wanted_metrics
        end

        def parse_all(output)
          YAML.load_documents(output).each do |hash|
            parse(hash)
          end
        end

        def self.default_value_from(metric_code)
          0.0
        end

        private

        def parse_file_name(file_name)
          without_extension = file_name.rpartition('.').first
          without_extension.gsub('.', '_').gsub('/', '.')
        end

        def parse_class_name(analizo_module_name)
          analizo_module_name.split('::').last
        end

        def module_name(file_name, analizo_module_name)
          "#{parse_file_name(file_name)}.#{parse_class_name(analizo_module_name)}"
        end

        def new_metric_result(module_result, code, value)
          TreeMetricResult.create(metric: self.wanted_metrics[code].metric, value: value.to_f, module_result: module_result, metric_configuration_id: self.wanted_metrics[code].id)
        end

        def module_result(module_name, granularity)
          kalibro_module = KalibroModule.new({long_name: module_name, granularity: granularity})
          module_result = ModuleResult.find_by_module_and_processing(kalibro_module, self.processing)

          if module_result.nil?
            kalibro_module.save
            module_result = ModuleResult.create(processing: self.processing)
            module_result.update(kalibro_module: kalibro_module)
          end
          return module_result
        end

        def parse(result_map)
          if result_map['_filename'].nil?
            module_result = module_result("ROOT", KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE)
            self.processing.update!(root_module_result: module_result)
          else
            module_result = module_result(module_name(result_map['_filename'].last, result_map['_module']), KalibroClient::Entities::Miscellaneous::Granularity::CLASS)
          end

          result_map.each do |code, value|
            new_metric_result(module_result, code, value) if (self.wanted_metrics[code])
          end

          module_result
        end
      end
    end
  end
end
