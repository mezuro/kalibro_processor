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
      revert = `svn revert -R #{directory}`
      update = `svn update #{directory}`
      raise Errors::SvnExecuteError.new('Failed to update svn repository') if revert.nil? || update.nil?
    end

    def self.checkout(address, directory)
      # Copy contents of address to a new directory
      name = directory.split('/').last
      path = (directory.split('/') - [name]).join('/')
      checkout = `svn checkout #{address} #{directory}`
      raise Errors::SvnExecuteError.new('Failed to checkout to svn repository') if checkout.nil?
    end
  end
end
