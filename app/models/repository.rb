class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :processings

  validates :name, presence: true
  validates :name, uniqueness: { scope: :project_id ,
    message: "should be unique within project" }
  validates :address, presence: true
  validates :configuration_id, presence: true
  validates :project_id, presence: true

  TYPES = {"GIT" => Downloaders::GitDownloader, "SVN" => Downloaders::SvnDownloader}

  def self.supported_types
    supported_types = []
    TYPES.select {|type, klass| supported_types << type if klass.available? }
    return supported_types
  end

  def configuration
    KalibroGatekeeperClient::Entities::Configuration.find(self.configuration_id)
  end

  def configuration=(conf)
    self.configuration_id = conf.id
  end

  def process; raise NotImplementedError; end
end
