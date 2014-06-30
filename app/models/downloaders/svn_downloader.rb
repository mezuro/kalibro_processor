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

    
  end
end