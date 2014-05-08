class AnalizoMetricCollector < MetricCollector
  attr_reader :description

  def name
    "Analizo"
  end

  def description
    CollectorsDescriptions.analizo_description
  end

  def metric_list
    `analizo metrics --list`
  end
end