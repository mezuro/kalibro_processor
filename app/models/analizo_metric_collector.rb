class AnalizoMetricCollector < MetricCollector
  attr_reader :description, :supported_metrics
  attr_accessor :wanted_metrics

  def initialize
    @description = YAML.load_file('config/collectors_descriptions.yml')["analizo"]
    @supported_metrics = parse_supported_metrics
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
    `analizo metrics --list`
  end

  def execute_analizo(absolute_path)
    `analizo metrics #{absolute_path}`
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
end