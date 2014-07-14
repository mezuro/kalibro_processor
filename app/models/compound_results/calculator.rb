module CompoundResults
  class calculator
    def initialize(root_module_result, native_metrics, compound_metrics)
      @current_module_result = root_module_result
      @native_metrics = native_metrics
      @compound_metrics = compound_metrics

    end

    def calculate
      evaluator = JavascriptEvaluator.new

    end
  end
end