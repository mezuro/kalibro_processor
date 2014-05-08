class AnalizoMetricCollector < MetricCollector
  attr_reader :description

  def name
    "Analizo"
  end

  def description
    CollectorsDescriptions.analizo_description
  end
end