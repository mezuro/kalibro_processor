module MetricCollector
  module Native
    class Analizo < MetricCollector::Base
      def initialize
        super("Analizo",
              YAML.load_file("#{Rails.root}/config/collectors_descriptions.yml")["analizo"],
              parse_supported_metrics)
      end

      def collect_metrics(code_directory, wanted_metrics, processing)
        self.wanted_metrics = wanted_metrics
        self.processing = processing
        parse(analizo_results(code_directory))
      end

      def self.available?
        `analizo --version`.nil? ? false : true
      end

      private

      def metric_list
        list = `analizo metrics --list`
        raise Errors::NotFoundError.new("BaseTool Analizo not found") if list.nil?
        list
      end

      def analizo_results(absolute_path)
        results = `analizo metrics #{absolute_path}`
        raise Errors::NotFoundError.new("BaseTool Analizo not found") if results.nil?
        raise Errors::NotReadableError.new("Directory not readable") if results.empty?
        results
      end

      def parse_supported_metrics
        supported_metrics = {}
        analizo_metric_list = metric_list
        global = true
        analizo_metric_list.each_line do |line|
          if line.include?("-")
            code = line[/^[^ ]*/] # From the beginning of line to the first space
            name = line[/- .*$/].slice(2..-1) # After the "- " to the end of line
            scope = global ? :SOFTWARE : :CLASS
            supported_metrics[code] = NativeMetric.new(name, code, scope, [:C, :CPP, :JAVA])
          elsif line.include?("Module Metrics:")
            global = false
          end
        end
        supported_metrics
      end

      def new_metric_result(module_result, code, value)
        MetricResult.create(metric: self.wanted_metrics[code].metric, value: value.to_f, module_result: module_result, metric_configuration_id: self.wanted_metrics[code].id)
      end

      def parse_file_name(file_name)
        file_name_tokenized = file_name.to_s.split("/")
        file_name_tokenized[file_name_tokenized.size - 1] = remove_extension(file_name_tokenized.last)
        file_name_tokenized.join(".")
      end


      def module_result(module_name, granularity)
        kalibro_module = KalibroModule.new({long_name: module_name, granularity: granularity})
        module_result = ModuleResult.find_by_module_and_processing(kalibro_module, self.processing)

        if module_result.nil?
          kalibro_module.save
          ModuleResult.create(kalibro_module: kalibro_module, processing: self.processing)
        else
          module_result
        end
      end

      def parse_single_result(result_map)
        if result_map['_filename'].nil?
          module_result = module_result("", Granularity::SOFTWARE)
        else
          module_result = module_result(parse_file_name(result_map['_filename'].last), Granularity::CLASS)
        end
        result_map.each do |code, value|
          new_metric_result(module_result, code, value) if (self.wanted_metrics[code])
        end
        module_result
      end

      def parse(results)
        YAML.load_documents(results).each do |hash|
          parse_single_result(hash)
        end
      end

      def remove_extension(name)
        list = name.split(".")
        if (list.size > 1)
          list.delete_at(list.size - 1)
        end
        list.join(".")
      end
    end
  end
end