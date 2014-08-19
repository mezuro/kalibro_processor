module Processor
  class CompoundResultCalculator < ProcessingStep

    protected

    def self.task(runner)
      self.calculate_compound_results(runner.processing.root_module_result, runner.compound_metrics)
    end

    def self.state
      "CALCULATING"
    end

    private

    def self.calculate_compound_results(module_result, compound_metric_configurations)
      unless module_result.children.empty?
        module_result.children.each { |child| calculate_compound_results(child, compound_metric_configurations) }
      end

      #TODO: there might exist the need to check the scope before trying to calculate
      CompoundResults::Calculator.new(module_result, compound_metric_configurations).calculate
    end
  end
end