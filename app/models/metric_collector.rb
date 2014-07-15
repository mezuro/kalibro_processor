class MetricCollector
  def initialize
    @wanted_metrics = {}
    @processing = nil
  end

  def self.description; raise NotImplementedError; end

  def self.supported_metrics; raise NotImplementedError; end

  def collect_metrics(code_directory, wanted_metrics); raise NotImplementedError; end

  protected

  def processing=(processing)
    @processing = processing
  end

  def wanted_metrics=(wanted_metric_configurations)
    @wanted_metrics = {}
    wanted_metric_configurations.each do |metric_configuration|
      if self.class.supported_metrics.keys.include?(metric_configuration.code)
        @wanted_metrics[metric_configuration.code] = metric_configuration
      end
    end
  end

  def wanted_metrics
    @wanted_metrics
  end

  def processing
    @processing
  end
end