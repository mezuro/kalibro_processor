require 'metric_collector'

module Processor
  class Collector < ProcessingStep
    protected

    def self.task(context)
      context.native_metrics.each do |metric_collector_name, wanted_metrics|
        unless wanted_metrics.empty?
          MetricCollector::Native::ALL[metric_collector_name].new.
            collect_metrics(context.repository.code_directory,
                            wanted_metrics,
                            context.processing)
        end
      end

      runner.processing.reload
      raise Errors::EmptyModuleResultsError if(runner.processing.module_results.empty?)
    end

    def self.state
      "COLLECTING"
    end
  end
end

