module Processor
  class Downloader < ProcessingStep

    protected

    def self.task(context)
      begin
        Repository::TYPES[context.repository.scm_type.upcase].retrieve!(context.repository.address, context.repository.code_directory)
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
