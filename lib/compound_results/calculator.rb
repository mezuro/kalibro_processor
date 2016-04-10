module CompoundResults
  class Calculator
    def initialize(module_result, compound_metric_configurations)
      @module_result = module_result
      @compound_metric_configurations = compound_metric_configurations
    end

    def calculate
      evaluator = JavascriptEvaluator.new

      @module_result.reload # reloads to make sure that all the metric results are available
      @module_result.tree_metric_results.each { |metric_result| evaluator.add_function(metric_result.metric_configuration.metric.code, "return #{metric_result.value};") }

      @module_result.hotspot_metric_results.each do |hotspot_metric_result|
        evaluator.add_function(hotspot_metric_result.metric_configuration.metric.code, "throw Error('Cannot use hotspot metric codes to create compound metrics.');")
      end

      @compound_metric_configurations.each do |compound_metric_configuration|
        evaluator.add_function(compound_metric_configuration.metric.code, compound_metric_configuration.metric.script)
      end

      @compound_metric_configurations.each do |compound_metric_configuration|
        value = evaluator.evaluate("#{compound_metric_configuration.metric.code}")
        if value.to_s != "Infinity" && value.to_s != "-Infinity" && value.to_s != "NaN"
          TreeMetricResult.create(metric: compound_metric_configuration.metric,
                                  module_result: @module_result,
                                  metric_configuration_id: compound_metric_configuration.id,
                                  value: value)
        end
      end
    end
  end
end
