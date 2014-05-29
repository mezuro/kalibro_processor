class MetricCollector
  def name; raise NotImplementedError; end

  def description; raise NotImplementedError; end

  def supported_metrics; raise NotImplementedError; end

  def collect_metrics(code_directory, wanted_metrics); raise NotImplementedError; end
end