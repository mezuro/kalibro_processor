class Repository < ActiveRecord::Base
  validates :name, presence: true
  validates :address, presence: true
  validates :configuration_id, presence: true
  validates :project_id, presence: true

  belongs_to :project

  def configuration
    KalibroGatekeeperClient::Entities::Configuration.find(self.configuration_id)
  end

  def configuration=(conf)
    self.configuration_id = conf.id
  end

	def complete_name
		self.project.name + "-" + self.name
	end
end
