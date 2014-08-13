module Processor
  class CompoundResultCalculator

    def self.calculate_compound_results(module_result, compound_metric_configurations)
      unless module_result.children.empty?
        module_result.children.each { |child| calculate_compound_results(child, compound_metric_configurations) }
      end

      #TODO: there might exist the need to check the scope before trying to calculate
      CompoundResults::Calculator.new(module_result, compound_metric_configurations).calculate
    end
  end
end