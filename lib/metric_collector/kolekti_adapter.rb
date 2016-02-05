module MetricCollector
  module KolektiAdapter
    def self.available
      Kolekti.collectors.select(&:available?)
    end

    def self.details
      # This cache will represent a HUGE improvement for MetricCollectorsController response times
      Rails.cache.fetch("metric_collector/kolekti/details", expires_in: 1.day) do
        @details = []

        available.each do |collector|
          @details << MetricCollector::Details.new(name: collector.name,
                                                   description: collector.description,
                                                   supported_metrics: collector.supported_metrics)
        end
      end

      @details
    end
  end
end
