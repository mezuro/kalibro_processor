class Repository < ActiveRecord::Base
	def initialize(attributes={})
		super(attributes)
		self.description = ""
		self.license = ""
		self.period = 0
	end
end
