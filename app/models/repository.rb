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
end
