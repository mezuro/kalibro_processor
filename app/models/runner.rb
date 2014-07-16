class Runner
  attr_accessor :repository, :native_metrics, :compound_metrics, :processing

  BASE_TOOLS = {"Analizo" => AnalizoMetricCollector}

  def initialize(repository)
    @repository = repository
    @native_metrics = {}
    BASE_TOOLS.each_key { |key| @native_metrics[key] = [] }
    @compound_metrics = []
  end

  def run
    self.processing = Processing.create(repository: self.repository, state: "PREPARING")

    self.repository.update(code_directory: generate_dir_name)
    metrics_list

    self.processing.update(state: "DOWNLOADING")

    Repository::TYPES[self.repository.scm_type.upcase].retrieve!(self.repository.address, self.repository.code_directory)

    self.processing.update(state: "COLLECTING")

    collect

    self.processing.update(state: "BUILDING")

    build_tree

    self.processing.update(state: "AGGREGATING")

    aggregate(self.processing.root_module_result)

    self.processing.update(state: "ANALYZING")
    self.processing.update(state: "READY")
  end

  private

  def generate_dir_name
    path = YAML.load_file("#{Rails.root}/config/repositories.yml")["repositories"]["path"]
    dir = path
    raise RuntimeError unless Dir.exists?(dir)
    while Dir.exists?(dir)
      dir = "#{path}/#{Digest::MD5.hexdigest(Time.now.to_s)}"
    end
    return dir
  end

  def metrics_list
    metric_configurations = KalibroGatekeeperClient::Entities::MetricConfiguration.metric_configurations_of(self.repository.configuration.id)
    metric_configurations.each do |metric_configuration|
      if metric_configuration.metric.compound
        self.compound_metrics << metric_configuration
      else
        self.native_metrics[metric_configuration.base_tool_name] << metric_configuration
      end
    end
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
    parent_module_result = ModuleResult.joins(:kalibro_module).
                      where(processing: self.processing).
                      where("kalibro_modules.long_name" => parent_module.long_name).
                      where("kalibro_modules.granlrty" => parent_module.granularity.to_s).first
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

    #FIXME: this should get unit test coverage when implementing the CALCULATING stage
    self.compound_metrics.each do |metric_configuration|
      return metric_configuration if metric_configuration.metric == metric
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
end