module Processor
  class Interpreter < ProcessingStep
    protected

    def self.task(context)
      all_module_results = context.processing.root_module_result.pre_order
      all_module_results.each do | module_result_child |
        numerator = 0
        denominator = 0
        module_result_child.tree_metric_results.each do |tree_metric_result|
          weight = tree_metric_result.metric_configuration.weight
          grade = tree_metric_result.has_grade? ? tree_metric_result.range.reading.grade : 0
          numerator += weight*grade
          denominator += weight
        end
        quotient = denominator == 0 ? 0 : numerator/denominator
        module_result_child.update(grade: quotient)
      end
    end

    def self.state
      "INTERPRETING"
    end
  end
end
