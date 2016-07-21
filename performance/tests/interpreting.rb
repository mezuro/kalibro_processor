require_relative '../performance'
require 'processor'

module Performance
  class Interpreting < ProcessingStepTest
    def setup
      super

      setup_ranges
      setup_metric_results(10, 4)
    end

    def subject
      Processor::Interpreter.task(context)

      puts "Interpreted results, average grade of all ModuleResults: #{processing.module_results.average(:grade)}"
    end
  end
end

if __FILE__ == $0
  Performance::Interpreting.new.run
end
