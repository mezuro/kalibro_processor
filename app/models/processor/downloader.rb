module Processor
  class Downloader < ProcessingStep

    protected

    def self.task(runner)
      Repository::TYPES[runner.repository.scm_type.upcase].retrieve!(runner.repository.address, runner.repository.code_directory)
    end

    def self.state
      "DOWNLOADING"
    end
  end
end
