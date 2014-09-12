module Processor
  class Preparer < ProcessingStep

    protected

    def self.task(runner)
      runner.repository.update(code_directory: generate_dir_name)
      metrics_list(runner)
    end

    def self.state
      "PREPARING"
    end

    private

    def self.generate_dir_name
      path = YAML.load_file("#{Rails.root}/config/repositories.yml")["repositories"]["path"]
      dir = path
      raise Errors::ProcessingError.new("Repository's directory (#{dir}) does not exist") unless Dir.exists?(dir)
      while Dir.exists?(dir)
        dir = "#{path}/#{Digest::MD5.hexdigest(Time.now.to_s)}"
      end
      return dir
    end

    def self.metrics_list(runner)
      metric_configurations = KalibroGatekeeperClient::Entities::MetricConfiguration.metric_configurations_of(runner.repository.configuration.id)
      metric_configurations.each do |metric_configuration|
        if metric_configuration.metric.compound
          runner.compound_metrics << metric_configuration
        else
          runner.native_metrics[metric_configuration.metric_collector_name] << metric_configuration
        end
      end
    end
  end
end
