require 'metric_collector'

class Runner
  attr_accessor :repository, :native_metrics, :compound_metrics, :processing

  BASE_TOOLS = {"Analizo" => MetricCollector::Native::Analizo}

  def initialize(repository, processing)
    @repository = repository
    @processing = processing
    @native_metrics = {}
    BASE_TOOLS.each_key { |key| @native_metrics[key] = [] }
    @compound_metrics = []
  end

  def run
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
    end
  end
end
