require 'metric_collector'
require 'processor'

class ProcessingJob < ActiveJob::Base
  queue_as :default

  before_perform do |job|
    @context = Processor::Context.new
  end

  rescue_from(Errors::ProcessingCanceledError) do
    @context.processing.destroy
  end

  rescue_from(Errors::ProcessingError) do |exception|
    @context.processing.update(state: 'ERROR', error_message: exception.message)
  end

  def perform(repository, processing)
    @context.repository = repository
    @context.processing = processing

    Processor::Preparer.perform(@context)
    Processor::Downloader.perform(@context)
    Processor::Collector.perform(@context)
    Processor::TreeBuilder.perform(@context)
    Processor::Aggregator.perform(@context)
    Processor::CompoundResultCalculator.perform(@context)
    Processor::Interpreter.perform(@context)

    @context.processing.update(state: "READY")
    rescue Errors::EmptyModuleResultsError
      self.processing.update(state: "READY")
  end
end
