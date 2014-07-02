class Runner
  attr_accessor :repository, :native_metrics, :compound_metrics

  BASE_TOOLS = {"Analizo" => AnalizoMetricCollector}

  def initialize(repository)
    @repository = repository
    @native_metrics = {}
    BASE_TOOLS.each_key { |key| @native_metrics[key] = [] }
    @compound_metrics = []
  end

  def run

    processing = Processing.create(repository: self.repository, state: "PREPARING")

    self.repository.update(code_directory: generate_dir_name)
    metrics_list

    processing.update(state: "DOWNLOADING")

    Repository::TYPES[self.repository.scm_type.upcase].retrieve!(self.repository.address, self.repository.code_directory)

    processing.update(state: "COLLECTING")

    collect(processing)

    processing.update(state: "BUILDING")

    build_tree(processing)

    processing.update(state: "AGGREGATING")
    processing.update(state: "ANALYZING")
    processing.update(state: "READY")
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

  def collect(processing)
    self.native_metrics.each do |base_tool_name, wanted_metrics|
      unless wanted_metrics.empty?
        BASE_TOOLS[base_tool_name].new.
          collect_metrics(repository.code_directory,
                          wanted_metrics.map {|metric_configuration| metric_configuration.code},
                          processing)
      end
    end
  end

  def build_tree(processing)
    offset = 0
    module_results = module_result_batch(processing, offset)
    while !module_results.empty?
      module_results.each do |module_result|
        parent_module = module_result.kalibro_module.parent
        parent_module_result = ModuleResult.joins(:kalibro_module).
                        where(processing: processing).
                        where("kalibro_modules.name" => parent_module.long_name).
                        where("kalibro_modules.granularity" => parent_module.granularity.to_s).first
        module_result.update(parent: parent_module_result)
      end
      offset += 100
      module_results = module_result_batch(processing, offset)
    end
  end

  def module_result_batch(processing, offset)
    ModuleResult.where(processing: processing).limit(100).offset(offset)
  end
end