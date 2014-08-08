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
      collect
      process_time.update(updated_at: DateTime.now)

      continue_processing?
      self.processing.update(state: "BUILDING")

      process_time = ProcessTime.create(state: "BUILDING", processing: @processing)
      build_tree
      process_time.update(updated_at: DateTime.now)

      continue_processing?
      self.processing.update(state: "AGGREGATING")

      process_time = ProcessTime.create(state: "AGGREGATING", processing: @processing)
      aggregate(self.processing.root_module_result)
      process_time.update(updated_at: DateTime.now)

      continue_processing?
      self.processing.update(state: "CALCULATING")

      process_time = ProcessTime.create(state: "CALCULATING", processing: @processing)
      calculate_compound_results(self.processing.root_module_result)
      process_time.update(updated_at: DateTime.now)

      continue_processing?
      self.processing.update(state: "INTERPRETATING")

      process_time = ProcessTime.create(state: "INTERPRETATING", processing: @processing)
      interpratate_results(self.processing.root_module_result)
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

  def collect
    self.native_metrics.each do |base_tool_name, wanted_metrics|
      unless wanted_metrics.empty?
        BASE_TOOLS[base_tool_name].new.
          collect_metrics(repository.code_directory,
                          wanted_metrics,
                          self.processing)
      end
    end
  end

  def build_tree
    offset = 0
    module_results = module_result_batch(self.processing, offset)
    while !module_results.empty?
      module_results.each do |module_result|
        set_parent(module_result, module_results)
      end
      offset += 100
      module_results = module_result_batch(self.processing, offset)
    end
  end

  def module_result_batch(processing, offset)
    ModuleResult.where(processing: self.processing).limit(100).offset(offset)
  end

  def parent_result(parent_module, module_results)
    parent_module_result = ModuleResult.find_by_module_and_processing(parent_module, self.processing)
    if parent_module_result.nil?
      parent_module_result = ModuleResult.create(kalibro_module: parent_module, processing: self.processing)
      module_results << parent_module_result
    end

    return parent_module_result
  end

  def set_parent(module_result, module_results)
    parent_module = module_result.kalibro_module.parent
    if parent_module.nil?
      self.processing.update(root_module_result: module_result)
    else
      module_result.update(parent: parent_result(parent_module, module_results))
    end
  end

  def metric_configuration(metric)
    self.native_metrics.each_value do |metric_configurations|
      metric_configurations.each do |metric_configuration|
        return metric_configuration if metric_configuration.metric == metric
      end
    end
  end

  def aggregate(module_result)
    unless module_result.children.empty?
      module_result.children.each { |child| aggregate(child) }
    end

    all_metrics = []
    self.native_metrics.each_value do |metric_configurations|
      metric_configurations.each do |metric_configuration|
        all_metrics << metric_configuration.metric
      end
    end

    already_calculated_metrics = module_result.metric_results.map { |metric_result| metric_result.metric}

    all_metrics.each do |metric|
      unless already_calculated_metrics.include?(metric)
        metric_result = MetricResult.new(metric: metric, module_result: module_result, metric_configuration_id: metric_configuration(metric).id)
        metric_result.value = metric_result.aggregated_value
        metric_result.save
      end
    end
  end

  def calculate_compound_results(module_result)
    unless module_result.children.empty?
      module_result.children.each { |child| calculate_compound_results(child) }
    end

    #TODO: there might exist the need to check the scope before trying to calculate
    CompoundResults::Calculator.new(module_result, @compound_metrics).calculate
  end

  def interpratate_results(module_result)
    unless module_result.children.empty?
      module_result.children.each { |child| interpratate_results(child) }
    end

    numerator = 0
    denominator = 0
    module_result.metric_results.each do |metric_result|
      weight = metric_result.metric_configuration.weight
      grade = metric_result.has_grade? ? metric_result.range.reading.grade : 0
      numerator += weight*grade
      denominator += weight
    end
    quotient = denominator == 0 ? 0 : numerator/denominator
    module_result.update(grade: quotient)
  end
end