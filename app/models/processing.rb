class Processing < ActiveRecord::Base
  belongs_to :repository
  belongs_to :root_module_result, foreign_key: 'root_module_result_id', class_name: 'ModuleResult'
  has_many :process_times
  has_many :module_results

  def self.find_by_repository_and_date(repository, date, order)
    Processing.where(repository: repository).where("updated_at #{order} :date", {date: date})
  end

  def self.find_ready_by_repository(repository)
    Processing.where(repository: repository, state: "READY")
  end
end