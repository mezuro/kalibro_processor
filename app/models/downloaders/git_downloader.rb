module Downloaders
  # Downloader sufix was put because otherwise it would conflict with the Git class from the git gem
  class GitDownloader < Base
    def self.available?
      begin
        Git.init
        return true
      rescue Git::GitExecuteError
        return false
      end
    end
  end
end