class Runner
  attr_accessor :repository, :native_metrics, :compound_metrics, :processing

  BASE_TOOLS = {"Analizo" => AnalizoMetricCollector}

  def initialize(repository, processing)
    @repository = repository
    @processing = processing
    @native_metrics = {}
    BASE_TOOLS.each_key { |key| @native_metrics[key] = [] }
    @compound_metrics = []
  end

  def run
    begin
      continue_processing?

      process_time = ProcessTime.create(state: "PREPARING", processing: @processing)
      Processor::Preparer.prepare(self)
      process_time.update(updated_at: DateTime.now)

      continue_processing?

      self.processing.update(state: "DOWNLOADING")

      process_time = ProcessTime.create(state: "DOWNLOADING", processing: @processing)
      Processor::Downloader.download(self)
      process_time.update(updated_at: DateTime.now)

      continue_processing?

      self.processing.update(state: "COLLECTING")

      process_time = ProcessTime.create(state: "COLLECTING", processing: @processing)
      Processor::Collector.collect(self)
      process_time.update(updated_at: DateTime.now)

      continue_processing?

      self.processing.update(state: "BUILDING")

      process_time = ProcessTime.create(state: "BUILDING", processing: @processing)
      Processor::TreeBuilder.build_tree(self.processing)
      process_time.update(updated_at: DateTime.now)

      continue_processing?
      self.processing.update(state: "AGGREGATING")

      process_time = ProcessTime.create(state: "AGGREGATING", processing: @processing)
      Processor::Aggregator.aggregate(self.processing.root_module_result, @native_metrics)
      process_time.update(updated_at: DateTime.now)

      continue_processing?
      self.processing.update(state: "CALCULATING")

      process_time = ProcessTime.create(state: "CALCULATING", processing: @processing)
      Processor::CompoundResultCalculator.calculate_compound_results(self.processing.root_module_result, @compound_metrics)
      process_time.update(updated_at: DateTime.now)

      continue_processing?
      self.processing.update(state: "INTERPRETING")

      process_time = ProcessTime.create(state: "INTERPRETING", processing: @processing)
      Processor::Interpreter.interpret(self.processing.root_module_result)
      process_time.update(updated_at: DateTime.now)

      self.processing.update(state: "READY")
    rescue Errors::ProcessingCanceledError
      self.processing.destroy
    end
  end

  private

  def continue_processing?
    raise Errors::ProcessingCanceledError if self.processing.state == "CANCELED"
  end
end
