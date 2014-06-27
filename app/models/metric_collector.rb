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

  def wanted_metrics=(wanted_metrics_list)
    @wanted_metrics = {}
    self.class.supported_metrics.each do |code, metric|
      if wanted_metrics_list.include?(code)
        @wanted_metrics[code] = metric
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