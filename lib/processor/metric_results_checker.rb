module Processor
  class MetricResultsChecker < ProcessingStep
    protected

    def metric_key(metric)
      metric.metric_collector_name.to_s + "#" + metric.code.to_s + "#" + metric.scope.to_s
    end

    def self.task(context)
      wanted_metrics = {}

      context.native_metrics.each do |metric_collector_name, metric_configurations|
        metric_configurations.each { |metric_configuration|
          wanted_metrics[metric_key(metric_configuration.metric)] = metric_configuration
        }
      end

      context.processing.module_results.each do |module_result|
        metrics_check_list = wanted_metrics.clone

        module_result.metric_results.each { |metric_result|
          metrics_check_list.delete(metric_key(metric_result.metric))
        }

        metrics_check_list.each do |metric, metric_configuration|
          MetricResult.create(value: default_value_from(metric),
                              module_result: module_result,
                              metric_configuration_id: metric_configuration.id)
        end
      end
    end

    def self.state
      "CHECKING"
    end

    private

    def self.default_value_from(metric)
      "MetricCollector::Native::#{metric.metric_collector_name}::Parser".constantize.default_value_from(metric.code)
    end
  end
end
