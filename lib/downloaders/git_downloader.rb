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

    def self.get(address, directory, branch)
      if Dir.exists?(directory) and is_git?(directory)
        g = Git.open(directory)
        remote = g.remote
        if remote.url != address
          g.remove_remote('origin')
          g.add_remote('origin', address)
        end

        checkout(directory, branch)
      else
        clone(address, directory, branch)
      end
    end

    def self.branches(url)
      # Some domains will ask for username and password
      # Avoid hanging on those cases by setting the ASK_PASS program to do nothing
      old_askpass = ENV['GIT_ASKPASS']
      ENV['GIT_ASKPASS'] = '/bin/true'
      branches = Git::Lib.new.ls_remote(url)["branches"].keys
      ENV['GIT_ASKPASS'] = old_askpass
      branches
    end

    private

    def self.is_git?(directory)
      Dir.exists?("#{directory}/.git")
    end

    def self.checkout(directory, branch)
      g = Git.open(directory)
      g.fetch
      g.checkout(branch)
      g.reset_hard("#{g.remote.name}/#{branch}")
    end

    def self.clone(address, directory, branch)
      # if directory is "/tmp/test", name is "test" and path is "/tmp"
      name = directory.split('/').last
      path = (directory.split('/') - [name]).join('/')
      branch = nil if !branch.nil? && branch.empty? # If no branch is specified, clone from the default branch
      Git.clone(address, name, path: path, branch: branch)
    end
  end
end
