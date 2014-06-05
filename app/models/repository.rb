class Repository < ActiveRecord::Base
  belongs_to :project

  validates :name, presence: true
  validates :name, uniqueness: { scope: :project_id ,
    message: "should be unique within project" }
  validates :address, presence: true
  validates :configuration_id, presence: true
  validates :project_id, presence: true

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
