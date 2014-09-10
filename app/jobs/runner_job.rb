require 'metric_collector'
require 'processor'

class RunnerJob < ActiveJob::Base
  queue_as :default

  attr_accessor :repository, :native_metrics, :compound_metrics, :processing

  before_perform do |job|
    job.native_metrics = {}
    MetricCollector::Native::ALL.each_key { |key| @native_metrics[key] = [] }
    job.compound_metrics = []
  end

  def perform(repository, processing)
    @repository = repository
    @processing = processing

    begin
      Processor::Preparer.perform(self)
      Processor::Downloader.perform(self)
      Processor::Collector.perform(self)
      Processor::TreeBuilder.perform(self)
      Processor::Aggregator.perform(self)
      Processor::CompoundResultCalculator.perform(self)
      Processor::Interpreter.perform(self)

      self.processing.update(state: "READY")
    rescue Errors::ProcessingCanceledError
      self.processing.destroy
    rescue Errors::ProcessingError => error
      self.processing.update(state: 'ERROR', error_message: error.message)
    rescue Errors::EmptyModuleResultsError
      self.processing.update(state: "READY")
    end
  end
end
