module MetricCollector
  module Native
    module Radon
      class Runner
        def initialize(attributes={repository_path: nil, chosen_metrics:["raw", "cc", "mi"]})
          @repository_path = repository_path
          @chosen_metrics = chosen_metrics

        end

        def repository_path
          @repository_path

        end
       
        def run
          for metric in chosen_metrics do
            collect_metric(metric)
          end
        end

        def clean_output
          for metric in @output_paths do
            File.delete(@output_paths[metric]) if File.exists?(@output_paths[metric])
          end
        end

        def chosen_metrics
          @chosen_metrics
        end

        def generate_output_paths
          @output_paths = {}
          for metric in chosen_metrics do
            file_path = @repository_path

            while File.exists?(file_path)
              @output_paths[metric] = "#{@repository_path}/#{Digest::MD5.hexdigest(Time.now.to_s)}.json"
            end
          end
          @output_paths
        end

        private

        def collect_metric(metric)
          Dir.chdir(@repository_path) { `radon #{metric} -s --json . > #{@output_paths[metric]}` }
        end
      end
    end
  end
end