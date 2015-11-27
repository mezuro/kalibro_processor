require 'fileutils'
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

    def self.get(address, directory, branch)
      if Dir.exist?(directory) and is_svn?(directory)
        if get_repository_url(directory) != address
          FileUtils.remove_entry_secure(directory, force=true)
          checkout(address, directory)
        else
          update(directory)
        end
      else
        checkout(address,directory)
      end
    end

    private

    def self.is_svn?(directory)
      Dir.exists?("#{directory}/.svn")
    end

    def self.update(directory)
      # Recursively revert the directory and its contents and then update it to the latest version
      revert = `svn revert -R #{directory}`
      update = `svn update #{directory}`
      raise Errors::SvnExecuteError.new('Failed to update svn repository') if revert.nil? || update.nil?
    end

    def self.checkout(address, directory)
      # Copy contents of address to a new directory
      checkout = `svn checkout #{address} #{directory}`
      raise Errors::SvnExecuteError.new('Failed to checkout to svn repository') if checkout.nil?
    end

    def self.get_repository_url(directory)
      info = `svn info #{directory}`
      unless info.nil?
        info.lines.each do |line|
          return line[5..-1].chomp if line.start_with? 'URL: '
        end
      end
      raise Errors::SvnExecuteError.new('Failed to retrieve repository info')
    end
  end
end
