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

    protected

    def self.updatable?; true; end

    def self.get(address, directory)
      if Dir.exist?(directory)
        raise NotimplementedError
      else
        # if directory is "/tmp/test", name is "test" and path is "path"
        name = directory.split('/').last
        path = (directory.split('/') - [name]).join('/')
        Git.clone(address, name, path: path)
      end
    end
  end
end