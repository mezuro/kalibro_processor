module Processor
	class Downloader

		def self.download(runner)
      		Repository::TYPES[runner.repository.scm_type.upcase].retrieve!(runner.repository.address, runner.repository.code_directory)
      	end
	end
end
