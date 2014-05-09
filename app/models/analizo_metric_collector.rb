class AnalizoMetricCollector < MetricCollector
  attr_reader :description, :supported_metrics

  def initialize
    @supported_metrics = Hash.new
    @description = YAML.load_file('config/collectors_descriptions.yml')["analizo"]
  end

  def name
    "Analizo"
  end

  def metric_list
    `analizo metrics --list`
  end

  def parse_supported_metrics
    analizo_metric_list = metric_list
    analizo_metric_list.each_line do |line|
      if line.include?("-")
        code = line[/^[^ ]*/] # From the beginning of line to the first space
        name = line[/- .*$/].slice(2..-1) # After the "- " to the end of line
        scope = code.start_with?("total") ? :SOFTWARE : :CLASS
        @supported_metrics[code] = Metric.new(false, name, scope)
      end
    end
    @supported_metrics
  end
end