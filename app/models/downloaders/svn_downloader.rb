module Downloaders
  class SvnDownloader < Base
    def self.available?
      svn_version = `svn --version`
      if svn_version.nil?
        return false
      else
        return true
      end
    end

    protected

    def self.updatable?; true; end

    def self.get(address, directory)
      if Dir.exist?(directory)
        update(directory)
      else
        checkout(address,directory)
      end
    end

    private

    def self.update(directory)
      # Recursively revert the directory and its contents and then update it to the latest version
      `svn revert -R #{directory}`
      `svn update #{directory}`
    end

    def self.checkout(address, directory)
      # Copy contents of address to a new directory
      name = directory.split('/').last
      path = (directory.split('/') - [name]).join('/')
      `svn checkout #{address} #{directory}`
    end

  end
end