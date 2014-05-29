class AnalizoMetricCollector < MetricCollector
  attr_reader :description, :supported_metrics
  attr_accessor :wanted_metrics

  def initialize
    @description = YAML.load_file('config/collectors_descriptions.yml')["analizo"]
  end

  def supported_metrics
    @supported_metrics ||= parse_supported_metrics
  end

  def wanted_metrics=(wanted_metrics_list)
    @wanted_metrics = {}
    self.supported_metrics.each do |code, metric|
      if wanted_metrics_list.include?(code)
        @wanted_metrics[code] = metric
      end
    end
  end

  def name
    "Analizo"
  end

  def metric_list
    list = `analizo metrics --list`
    raise Errors::NotFoundError.new("BaseTool #{name} not found") if list.nil?
    list
  end

  def analizo_results(absolute_path)
    results = `analizo metrics #{absolute_path}`
    raise Errors::NotFoundError.new("BaseTool #{name} not found") if results.nil?
    results
  end

  def parse_supported_metrics
    supported_metrics = {}
    analizo_metric_list = metric_list
    analizo_metric_list.each_line do |line|
      if line.include?("-")
        code = line[/^[^ ]*/] # From the beginning of line to the first space
        name = line[/- .*$/].slice(2..-1) # After the "- " to the end of line
        scope = code.start_with?("total") ? :SOFTWARE : :CLASS
        supported_metrics[code] = NativeMetric.new(name, scope, [:C, :CPP, :JAVA])
      end
    end
    supported_metrics
  end

  def new_metric_result(module_result, code, value)
    module_result.metric_results.create(metric: self.wanted_metrics[code], value: value.to_f)
  end

  def new_module_result(result_map)
    module_name = result_map["_module"]
    granularity = module_name.nil? ? :SOFTWARE : :CLASS
    kalibro_module = KalibroModule.new(granularity: granularity, name: module_name.to_s.split(/:+/))
    ModuleResult.create(kalibro_module: kalibro_module)
  end

  def parse_single_result(result_map)
    module_result = new_module_result(result_map)
    result_map.each do |code, value|
       new_metric_result(module_result, code, value) if (self.wanted_metrics[code])
    end
    module_result
  end

  def parse(results)
    YAML.load_stream(results).each do |hash|
      parse_single_result(hash)
    end
  end

  def collect_metrics(code_directory, wanted_metrics)
    self.wanted_metrics = wanted_metrics
    parse analizo_results
  end
end