class Repository < ActiveRecord::Base
  validates :name, presence: true
  validates :address, presence: true
  validates :configuration_id, presence: true

  def configuration
    KalibroGatekeeperClient::Entities::Configuration.find(self.configuration_id)
  end

  def configuration=(conf)
    self.configuration_id = conf.id
  end

	def complete_name
		KalibroGatekeeperClient::Entities::Project.find(self.project_id).name + "-" + self.name
	end
end
