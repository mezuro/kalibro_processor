module Downloaders
  class Base
    def self.available?; raise NotImplementedError; end

    def self.retrieve!(address, directory)
      Dir.delete(directory) if Dir.exist?(directory) && !updatable?
      get(address, directory)
    end

    protected

    def self.updatable?; raise NotImplementedError; end

    def self.get(address, directory); raise NotImplementedError; end
  end
end