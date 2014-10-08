module MetricCollector
  module Native
    module MetricFu
      class Runner
        def initialize(attributes={repository_path: nil})
          @repository_path = attributes[:repository_path]
          @yaml_path = generate_output_path
        end

        def run
          Dir.chdir(@repository_path) { `metric_fu --format yaml --output #{@yaml_path}` }
        end

        def yaml_path
          @yaml_path
        end

        def clean_output
          File.delete(@yaml_path) if File.exists?(@yaml_path)
        end

        private

        def generate_output_path
          file_path = @repository_path

          while File.exists?(file_path)
            file_path = "#{@repository_path}/#{Digest::MD5.hexdigest(Time.now.to_s)}.yml"
          end

          return file_path
        end
      end
    end
  end
end