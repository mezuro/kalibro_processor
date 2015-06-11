require 'downloaders/base'
require 'downloaders/git_downloader'
require 'downloaders/svn_downloader'


module Downloaders
  ALL = {"GIT" => Downloaders::GitDownloader, "SVN" => Downloaders::SvnDownloader}
end
