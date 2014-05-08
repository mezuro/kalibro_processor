class AnalizoMetricCollector < MetricCollector
  attr_reader :description

  def initialize
    @description = YAML.load_file('config/collectors_descriptions.yml')["analizo"]
  end

  def name
    "Analizo"
  end

  def metric_list
    `analizo metrics --list`
  end
end