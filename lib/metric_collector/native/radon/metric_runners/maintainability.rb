module MetricCollector
  module Native
    module Radon
      module MetricRunners
        class Maintainability
          def self.run(repository_path)
            Dir.chdir(repository_path) { `radon mi -s --json . > radon_mi_output.json` }
          end

          def self.clean_output
            File.delete('radon_mi_output.json') if File.exists?('radon_mi_output.json')
          end
        end
      end
    end
  end
end
