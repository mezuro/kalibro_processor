class Repository < ActiveRecord::Base
	attr_accessor :description, :license, :address, :type, :process_period, :configuration, :project
	attr_reader :name

	def initialize(name, type, address)
		@name = name
		@type = type
		@address = address
		@description = ""
		@license = ""
		@process_period = 0
	end
end