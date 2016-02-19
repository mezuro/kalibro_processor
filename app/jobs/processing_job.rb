require 'metric_collector'
require 'processor'

class ProcessingJob < ActiveJob::Base
  queue_as :default

  before_perform do |job|
    @context = Processor::Context.new
  end

  after_perform do |job|
    period = @context.repository.period
    ScheduledProcessingJob.set(wait: period.days).perform_later(@context.repository) if period > 0
  end

  # As for Rails 4.2.4 with Ruby 2.2.3, the rescue order is bottom up
  # So this general rescue should come first to be the last one handled
  rescue_from(Exception) do |exception|
    ExceptionNotifier.notify_exception(exception)
    @context.processing.update(state: 'ERROR', error_message: exception.message) if exception.is_a?(NoMethodError)
    raise exception
  end

  rescue_from(Errors::ProcessingCanceledError) do
    @context.processing.destroy
  end

  rescue_from(Errors::ProcessingError) do |exception|
    @context.processing.update(state: 'ERROR', error_message: exception.message)
  end

  rescue_from(Errors::EmptyModuleResultsError) do
    @context.processing.update(state: "READY")
  end

  def perform(repository, processing)
    @context.repository = repository
    @context.processing = processing

    Processor::Preparer.perform(@context)
    Processor::Downloader.perform(@context)
    Processor::Collector.perform(@context)
    Processor::MetricResultsChecker.perform(@context)
    Processor::TreeBuilder.perform(@context)
    Processor::Aggregator.perform(@context)
    Processor::CompoundResultCalculator.perform(@context)
    Processor::Interpreter.perform(@context)

    @context.processing.update(state: "READY")
  end
end
