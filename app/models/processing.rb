class Processing < ActiveRecord::Base
  belongs_to :repository
  belongs_to :root_module_result, foreign_key: 'root_module_result_id', class_name: 'ModuleResult'
  has_many :process_times, dependent: :destroy
  has_many :module_results, dependent: :destroy
end