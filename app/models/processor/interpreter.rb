module Processor
  class Interpreter
    def self.interpret(module_result)
      all_module_results = module_result.subtree_elements
      all_module_results.each do | module_result_child |
        numerator = 0
        denominator = 0
        module_result_child.metric_results.each do |metric_result|
          weight = metric_result.metric_configuration.weight
          grade = metric_result.has_grade? ? metric_result.range.reading.grade : 0
          numerator += weight*grade
          denominator += weight
        end
        quotient = denominator == 0 ? 0 : numerator/denominator
        module_result_child.update(grade: quotient)
      end
    end
  end
end
