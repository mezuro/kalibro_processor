require 'metric_collector'

module Processor
  class Collector < ProcessingStep
    protected

    def self.task(runner)
      runner.native_metrics.each do |base_tool_name, wanted_metrics|
        unless wanted_metrics.empty?
          MetricCollector::Native::ALL[base_tool_name].new.
            collect_metrics(runner.repository.code_directory,
                            wanted_metrics,
                            runner.processing)
        end
      end
    end

    def self.state
      "COLLECTING"
    end
  end
end

