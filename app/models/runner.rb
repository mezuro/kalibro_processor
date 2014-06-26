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
    processing = Processing.create(repository: self.repository, state: "LOADING")
    self.repository.code_directory = generate_dir_name
    Repository::TYPES[self.repository.scm_type.upcase.to_sym].retrieve!(self.repository.address, self.repository.code_directory)
    wanted_metrics_list
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

  def wanted_metrics_list
    metric_configurations = KalibroGatekeeperClient::Entities::MetricConfiguration.metric_configurations_of(self.repository.configuration.id)
    metric_configurations.each do |metric_configuration|
      if metric_configuration.metric.compound
        self.compound_metrics << metric_configuration
      else
        self.native_metrics[metric_configuration.base_tool_name] << metric_configuration
      end
    end
  end
end