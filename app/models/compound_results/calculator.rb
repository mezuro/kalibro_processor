module CompoundResults
  class Calculator
    def initialize(module_result, compound_metric_configurations)
      @module_result = module_result
      @compound_metric_configurations = compound_metric_configurations
    end

    def calculate
      evaluator = JavascriptEvaluator.new

      @module_result.metric_results.each { |metric_result| evaluator.add_variable(metric_result.metric_configuration.code, metric_result.value) }

      @compound_metric_configurations.each do |compound_metric_configuration|
        evaluator.add_function(compound_metric_configuration.code, compound_metric_configuration.metric.script)
      end

      @compound_metric_configurations.each do |compound_metric_configuration|
        MetricResult.create(metric: compound_metric_configuration.metric,
                            module_result: @module_result,
                            metric_configuration_id: compound_metric_configuration.id,
                            value: evaluator.evaluate(compound_metric_configuration.code))
      end
    end
  end
end