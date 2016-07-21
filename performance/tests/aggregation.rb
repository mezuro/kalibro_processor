require_relative '../performance'
require 'processor'

module Performance
  class Aggregation < ProcessingStepTest
    def setup
      super

      setup_metric_results(2, 10)
    end

    def subject
      Processor::Aggregator.task(context)
    end

    def teardown
      puts "Aggregation produced #{ModuleResult.count} ModuleResults and #{MetricResult.count} MetricResults"
      super
    end

    protected
  end
end

if __FILE__ == $0
  Performance::Aggregation.new.run
end
