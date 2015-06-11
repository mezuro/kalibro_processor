module Downloaders
  class Base

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
