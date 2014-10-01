require 'compound_results'

module Processor
  class CompoundResultCalculator < ProcessingStep

    protected

    def self.task(context)
      self.calculate_compound_results(context.processing.root_module_result.pre_order, context.compound_metrics)
    end

    def self.state
      "CALCULATING"
    end

    private

    def self.calculate_compound_results(pre_order_module_results, compound_metric_configurations)
      # The upper nodes of the tree need the children to be calculated first, so we reverse the pre_order
      pre_order_module_results.reverse_each do | module_result |
        begin
          #TODO: there might exist the need to check the scope before trying to calculate
          CompoundResults::Calculator.new(module_result, compound_metric_configurations).calculate
        rescue V8::Error => error
          raise Errors::ProcessingError.new("Javascript error with message: #{error.message}")
        end
      end
    end
  end
end
