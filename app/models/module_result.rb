class ModuleResult < ActiveRecord::Base
  has_one :kalibro_module, dependent: :destroy #It can go wrong if someday we want to destroy only module results and not the whole processing
  has_many :children, foreign_key: 'parent_id', class_name: 'ModuleResult', dependent: :destroy
  has_many :metric_results, dependent: :destroy
  belongs_to :parent, class_name: 'ModuleResult'
  belongs_to :processing

  def self.find_by_module_and_processing(kalibro_module, processing)
    ModuleResult.joins(:kalibro_module).
      where(processing: processing).
      where("kalibro_modules.long_name" => kalibro_module.long_name).
      where("kalibro_modules.granlrty" => kalibro_module.granularity.to_s).first
  end

  def metric_result_for(metric)
    self.reload # reloads to get recently created MetricResults
    self.metric_results.each {|metric_result| return metric_result if metric_result.metric == metric}
    return nil
  end
end
