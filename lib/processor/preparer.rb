module Processor
  class Preparer < ProcessingStep

    protected

    def self.task(context)
      # Make sure no pre-existing processing times exist. This ensure a failed
      # processing does not leave leftovers.
      context.processing.process_times.destroy_all

      context.repository.update(code_directory: generate_dir_name)
      metrics_list(context)
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

    def self.metrics_list(context)
      metric_configurations = KalibroClient::Entities::Configurations::MetricConfiguration.metric_configurations_of(context.repository.kalibro_configuration.id)
      metric_configurations.each do |metric_configuration|
        if metric_configuration.metric.is_a?(KalibroClient::Entities::Miscellaneous::CompoundMetric)
          context.compound_metrics << metric_configuration
        else
          context.native_metrics[metric_configuration.metric.metric_collector_name] << metric_configuration
        end
      end
    end
  end
end
