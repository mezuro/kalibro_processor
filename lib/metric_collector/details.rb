module MetricCollector
  class Details
    attr_reader :name, :description, :supported_metrics

    def initialize(attributes={})
      @name = attributes[:name]
      @description = attributes[:description]
      @supported_metrics = attributes[:supported_metrics]
    end
  end
end