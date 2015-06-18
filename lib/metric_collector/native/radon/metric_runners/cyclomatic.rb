module MetricCollector
  module Native
    module Radon
      module MetricRunners
        class Cyclomatic
          def self.run(repository_path)
            Dir.chdir(repository_path) { `radon cc -s --json . > radon_cc_output.json` }
          end

          def self.clean_output
            File.delete('radon_cc_output.json') if File.exists?('radon_cc_output.json')
          end
        end
      end
    end
  end
end
