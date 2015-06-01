module Downloaders
  class Base
    require 'downloaders/git_downloader'
    require 'downloaders/svn_downloader'

    ALL = {"GIT" => Downloaders::GitDownloader, "SVN" => Downloaders::SvnDownloader}
    def self.available?; raise NotImplementedError; end

    def self.retrieve!(address, directory, branch)
      Dir.delete(directory) if Dir.exist?(directory) && !updatable?
      get(address, directory, branch)
    end

    protected

    def self.branches(url); raise NotImplementedError; end

    def self.updatable?; raise NotImplementedError; end

    def self.get(address, directory, branch); raise NotImplementedError; end
  end
end
