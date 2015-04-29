module MetricCollector
  module Native
    module Analizo
      class Collector < MetricCollector::Base
        def initialize
          super("Analizo",
                YAML.load_file("#{Rails.root}/lib/metric_collector/native/descriptions.yml")["analizo"],
                parse_supported_metrics)
        end

        def collect_metrics(code_directory, wanted_metric_configurations, processing)
          self.wanted_metrics = wanted_metric_configurations
          self.processing = processing

          runner = Runner.new(repository_path: code_directory)
          parser = Parser.new(processing: self.processing, wanted_metrics: self.wanted_metrics)

          parser.parse_all(runner.run)
        end

        def self.available?
          `analizo --version`.nil? ? false : true
        end

        def parse_supported_metrics
          supported_metrics = {}
          analizo_metric_list = metric_list
          global = true
          analizo_metric_list.each_line do |line|
            if line.include?("-")
              code = line[/^[^ ]*/] # From the beginning of line to the first space
              name = line[/- .*$/].slice(2..-1) # After the "- " to the end of line
              scope = global ? :SOFTWARE : :CLASS
              supported_metrics[code] = KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, [:C, :CPP, :JAVA], "Analizo")
            elsif line.include?("Module Metrics:")
              global = false
            end
          end
          supported_metrics
        end

        private

        def metric_list
          list = `analizo metrics --list`
          raise Errors::NotFoundError.new("BaseTool Analizo not found") if list.nil?
          list
        end
      end
    end
  end
end
