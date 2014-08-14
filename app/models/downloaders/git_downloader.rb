module Downloaders
  # Downloader sufix was put because otherwise it would conflict with the Git class from the git gem
  class GitDownloader < Base
    def self.available?
      git_version = `git --version`
      if git_version.nil?
        return false
      else
        return true
      end
    end

    protected

    def self.updatable?; true; end

    def self.get(address, directory)
      if Dir.exist?(directory)
        reset(directory)
      else
        clone(address, directory)
      end
    end

    private

    def self.clone(address, directory)
      # if directory is "/tmp/test", name is "test" and path is "/tmp"
      name = directory.split('/').last
      path = (directory.split('/') - [name]).join('/')
      Git.clone(address, name, path: path)
    end

    def self.reset(directory)
      g = Git.open(directory)
      g.fetch
      g.reset("#{g.remote.name}/#{g.branch.name}", hard: true)
    end
  end
end