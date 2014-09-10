module Processor
  class Downloader < ProcessingStep

    protected

    def self.task(runner)
      begin
        Repository::TYPES[runner.repository.scm_type.upcase].retrieve!(runner.repository.address, runner.repository.code_directory)
      rescue Git::GitExecuteError => error
        raise Errors::ProcessingError.new("Failed to download code with message: #{error.message}")
      rescue Errors::SvnExecuteError => error
        raise Errors::ProcessingError.new("Failed to download code with message: #{error.message}")
      end
    end

    def self.state
      "DOWNLOADING"
    end
  end
end
