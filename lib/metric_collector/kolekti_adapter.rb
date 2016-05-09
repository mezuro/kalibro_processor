module MetricCollector
  module KolektiAdapter
    def self.available
      Kolekti.collectors
    end

    def self.details
      available.map do |collector|
        MetricCollector::Details.new(name: collector.name,
                                     description: collector.description,
                                     supported_metrics: collector.supported_metrics)
      end
    end
  end
end
