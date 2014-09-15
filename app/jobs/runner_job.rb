require 'metric_collector'
require 'processor'

class RunnerJob < ActiveJob::Base
  queue_as :default

  before_perform do |job|
    @context = Processor::Context.new
  end

  def perform(repository, processing)
    @context.repository = repository
    @context.processing = processing

    begin
      Processor::Preparer.perform(context)
      Processor::Downloader.perform(context)
      Processor::Collector.perform(context)
      Processor::TreeBuilder.perform(context)
      Processor::Aggregator.perform(context)
      Processor::CompoundResultCalculator.perform(context)
      Processor::Interpreter.perform(context)

      context.processing.update(state: "READY")
    rescue Errors::ProcessingCanceledError
      context.processing.destroy
    rescue Errors::ProcessingError => error
      context.processing.update(state: 'ERROR', error_message: error.message)
    rescue Errors::EmptyModuleResultsError
      self.processing.update(state: "READY")
    end
  end
end
