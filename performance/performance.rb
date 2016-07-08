ENV["RAILS_ENV"] ||= "test"

require 'ruby-prof'
require_relative '../config/environment'

require_relative 'base'

module Performance; end
