module Processor
  class Aggregator
    def self.aggregate(root_module_result, native_metrics)
      @native_metrics = native_metrics
      set_all_metrics

      aggregate_module(root_module_result)
    end

    private

    def self.aggregate_module(module_result)
      children = module_result.children
      unless children.empty?
        children.each { |child| aggregate_module(child) }
      end

      already_calculated_metric_results = module_result.metric_results.map { |metric_result| metric_result.metric}

      @all_metrics.each do |metric|
        unless already_calculated_metric_results.include?(metric)
          metric_result = MetricResult.new(metric: metric, module_result: module_result, metric_configuration_id: metric_configuration(metric).id)
          metric_result.value = metric_result.aggregated_value
          metric_result.save
        end
      end
    end

    def self.set_all_metrics
      @all_metrics = []
      @native_metrics.each_value do |metric_configurations|
        metric_configurations.each do |metric_configuration|
          @all_metrics << metric_configuration.metric
        end
      end
    end

    def self.metric_configuration(metric)
      @native_metrics.each_value do |metric_configurations|
        metric_configurations.each do |metric_configuration|
          return metric_configuration if metric_configuration.metric == metric
        end
      end
    end
  end
end