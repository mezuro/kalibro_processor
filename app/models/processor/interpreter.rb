module Processor
  class Interpreter
    def self.interpret(module_result)
      children = module_result.children
      unless children.empty?
        children.each { |child| interpret(child) }
      end

      numerator = 0
      denominator = 0
      module_result.metric_results.each do |metric_result|
        weight = metric_result.metric_configuration.weight
        grade = metric_result.has_grade? ? metric_result.range.reading.grade : 0
        numerator += weight*grade
        denominator += weight
      end
      quotient = denominator == 0 ? 0 : numerator/denominator
      module_result.update(grade: quotient)
    end
  end
end
