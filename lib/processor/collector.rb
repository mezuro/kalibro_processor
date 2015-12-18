require 'set'
require 'kolekti'

require 'metric_collector'

module Processor
  class Collector < ProcessingStep
    protected

    def self.task(context)
      kolekti_collector_names = Set.new(Kolekti.available_collectors.map(&:name))
      kolekti_metrics, native_metrics = context.native_metrics.partition do |metric_collector_name, _|
        kolekti_collector_names.include? metric_collector_name
      end

      native_metrics, unknown_metrics = native_metrics.partition do |metric_collector_name, _|
        MetricCollector::Native::ALL.include? metric_collector_name
      end

      # Work around the fact that Hash#partition does not return hashes
      kolekti_metrics = Hash[kolekti_metrics]
      native_metrics = Hash[native_metrics]
      unknown_metrics = Hash[unknown_metrics]

      unless unknown_metrics.empty?
        unknown_collector_names = unknown_metrics.keys.uniq.join(', ')
        raise Errors::NotFoundError.new("Metric collectors #{unknown_collector_names} not found")
      end

      collect_kolekti_metrics(context, kolekti_metrics)
      collect_native_metrics(context, native_metrics)

      context.processing.reload
      raise Errors::EmptyModuleResultsError if context.processing.module_results.empty?
    end

    def self.collect_native_metrics(context, wanted_metrics)
      wanted_metrics.each do |metric_collector_name, metrics|
        collector = MetricCollector::Native::ALL[metric_collector_name].new
        collector.collect_metrics(context.repository.code_directory, metrics, context.processing)
      end
    end

    def self.collect_kolekti_metrics(context, wanted_metrics)
      persistence_strategy = MetricCollector::PersistenceStrategy.new(context.processing)
      runner = Kolekti::Runner.new(context.repository.code_directory, wanted_metrics.values.flatten, persistence_strategy)

      begin
        runner.run_wanted_metrics
      ensure
        runner.clean_output
      end
    end

    def self.state
      "COLLECTING"
    end
  end
end

