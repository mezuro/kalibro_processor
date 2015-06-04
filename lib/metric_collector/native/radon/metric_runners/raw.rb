module MetricCollector
  module Native
    module Radon
    	module MetricRunners
    		class Raw
          def self.run(repository_path)
            Dir.chdir(repository_path) { `radon raw -s --json . > radon_raw_output.json` } unless File.exists?('radon_raw_output.json')

          end

          def self.clean_output
            File.delete('radon_raw_output.json') if File.exists?('radon_raw_output.json')
          end
    		end
    	end
    end
	end
end
