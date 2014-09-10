require 'downloaders'

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

  def process(processing)
    RunnerJob.perform_later(self, processing)
  end

  def module_result_history_of(module_name)
    history = []
    self.processings.each do |processing|
      module_result = processing.module_results.select { |module_result| module_result.kalibro_module.long_name == module_name }.first
      history << [processing.updated_at, module_result] unless module_result.nil?
    end
    return history
  end

  def metric_result_history_of(module_name, metric_name)
    history = []
    self.processings.each do |processing|
      module_result = processing.module_results.select { |module_result| module_result.kalibro_module.long_name == module_name }.first
      unless module_result.nil?
        module_result.metric_results.each do |metric_result|
          history << [processing.updated_at, metric_result.value] if metric_result.metric.name == metric_name
        end
      end
    end
    return history
  end

  def find_processing_by_date(date, order)
    self.processings.where("updated_at #{order} :date", {date: date})
  end

  def find_ready_processing
    self.processings.where(state: "READY")
  end
end
