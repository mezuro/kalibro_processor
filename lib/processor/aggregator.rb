require 'metric_result_aggregator'

module Processor
  class Aggregator < ProcessingStep
    protected

    def self.task(runner)
      @native_metrics = runner.native_metrics
      set_all_metrics
      aggregate(runner.processing.root_module_result.pre_order)
    end

    def self.state
      "AGGREGATING"
    end

    private

    def self.aggregate(pre_order_module_results)
      # The upper nodes of the tree need the children to be calculated first, so we reverse the pre_order
      pre_order_module_results.reverse_each do | module_result_child |

        already_calculated_metrics = module_result_child.metric_results.map { |metric_result| metric_result.metric}

        remaining_metrics = @all_metrics.reject { |metric| already_calculated_metrics.include?(metric) }

        remaining_metrics.each do |metric|
          if module_result_child.kalibro_module.granularity > Granularity.new(metric.scope.to_s.to_sym)
            metric_result = MetricResult.new(metric: metric, module_result: module_result_child, metric_configuration_id: metric_configuration(metric).id)
            metric_result.value = MetricResultAggregator.aggregated_value(metric_result)
            metric_result.save
          end
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
