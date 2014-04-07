class BaseTool
  attr_reader :name, :description, :collector_class_name, :supported_metrics

  def initialize(name, description, collector_class_name, supported_metrics)
    @name = name
    @description = description
    @collector_class_name = collector_class_name
    @supported_metrics = supported_metrics
  end

  def find_supported_metric_by_name(metric_name)
    supported_metrics.each { |metric| return metric if metric.name == metric_name }
    raise Errors::NotFoundError.new("BaseTool #{@name} doesn't support the metric: #{metric_name}")
  end

  def collect_metrics(code_directory, wanted_metrics, result_writer)
    raise NotImplementedError.new
  end

  private

  def metric_collector()
    raise NotImplementedError.new
  end
end