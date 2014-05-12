class AnalizoMetricCollector < MetricCollector
  attr_reader :description, :supported_metrics, :wanted_metrics

  def initialize
    @description = YAML.load_file('config/collectors_descriptions.yml')["analizo"]
    @supported_metrics = parse_supported_metrics
  end

  def result_parser(wanted_metrics)
    self.wanted_metrics = Hash.new
    @supported_metrics.each_key do |code|
      if wanted_metrics.include?(@supported_metrics[code])
        self.wanted_metrics.store(code, @supported_metrics[code])
      end
    end
  end

  def metric_result(code, result)
    native_metric_result(@wanted_metric[code], result.to_f)
  end

  def native_metric_result(code,result)
        raise NotImplementedError.new    
  end

  def name
    "Analizo"
  end

  def metric_list
    `analizo metrics --list`
  end

  def parse_supported_metrics
    supported_metrics = Hash.new
    analizo_metric_list = metric_list
    analizo_metric_list.each_line do |line|
      if line.include?("-")
        code = line[/^[^ ]*/] # From the beginning of line to the first space
        name = line[/- .*$/].slice(2..-1) # After the "- " to the end of line
        scope = code.start_with?("total") ? :SOFTWARE : :CLASS
        supported_metrics[code] = Metric.new(false, name, scope)
      end
    end
    supported_metrics
  end
end