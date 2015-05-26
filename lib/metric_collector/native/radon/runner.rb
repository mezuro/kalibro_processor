module MetricCollector
  module Native
    module Radon
      class Runner
        def initialize(attributes={repository_path: nil})
          @repository_path = attributes[:repository_path]
        end

        def run
          run_cyclomatic_complexity
          run_maintainability
          run_raw
        end

        def clean_output
          File.delete('radon_cc_output.json') if File.exists?('radon_cc_output.json')
          File.delete('radon_mi_output.json') if File.exists?('radon_mi_output.json')
          File.delete('radon_raw_output.json') if File.exists?('radon_raw_output.json')
        end

        private

        def run_cyclomatic_complexity
          Dir.chdir(@repository_path) { `radon cc -s --json . > radon_cc_output.json` }
        end

        def run_maintainability
          Dir.chdir(@repository_path) { `radon mi -s --json . > radon_mi_output.json` }
        end

        def run_raw
          Dir.chdir(@repository_path) { `radon raw -s --json . > radon_raw_output.json` }
        end

      end
    end
  end
end