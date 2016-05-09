module Processor
  class MetricResultsChecker < ProcessingStep
    protected

    def self.task(context)
      wanted_metrics = {}

      context.native_metrics.each do |metric_collector_name, metric_configurations|
        metric_configurations.each { |metric_configuration|
          wanted_metrics[metric_key(metric_configuration.metric)] = metric_configuration
        }
      end

      module_results = context.processing.module_results - [context.processing.root_module_result]
      module_results.each do |module_result|
        metrics_check_list = wanted_metrics.clone

        module_result.tree_metric_results.each do |tree_metric_result|
          metrics_check_list.delete(metric_key(tree_metric_result.metric))
        end

        native_metrics = metrics_check_list.select do |metric_key, metric_configuration|
          !metric_configuration.metric.is_a?(KalibroClient::Entities::Miscellaneous::HotspotMetric)
        end

        native_metrics.each do |metric_key, metric_configuration|
          TreeMetricResult.create(value: default_value_from(metric_configuration),
                              module_result: module_result,
                              metric_configuration_id: metric_configuration.id)
        end
      end
    end

    def self.state
      "CHECKING"
    end

    private

    def self.metric_key(metric)
      metric.metric_collector_name.to_s + "#" + metric.code.to_s + "#" + metric.scope.to_s
    end

    def self.default_value_from(metric_configuration)
      Kolekti.default_metric_value(metric_configuration)
    end
  end
end
