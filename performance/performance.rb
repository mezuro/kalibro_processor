ENV["RAILS_ENV"] ||= "test"

require 'ruby-prof'
require_relative '../config/environment'

require_relative 'base'
require_relative 'processing_step_test'

module Performance; end
