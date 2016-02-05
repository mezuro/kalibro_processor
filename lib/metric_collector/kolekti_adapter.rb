module MetricCollector
  module KolektiAdapter
    def self.available
      Kolekti.collectors.select { |collector| collector.available? }
    end

    def self.details
      # This cache will represent a HUGE improvement for MetricCollectorsController response times
      Rails.cache.fetch("metric_collector/kolekti/details", expires_in: 1.day) do
        @details = []

        self.available.each do |collector|
          @details << MetricCollector::Details.new(name: collector.name,
                                                   description: collector.description,
                                                   supported_metrics: collector.supported_metrics)
        end
      end

      return @details
    end
  end
end