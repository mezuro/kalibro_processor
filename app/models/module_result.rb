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

  # Adding kalibro_module to the result
  def to_json(options={})
    json = super(options)
    hash = JSON.parse(json)
    hash["kalibro_module"] = kalibro_module
    hash.to_json
  end

  def subtree_elements
    descendants = [self]
    descendants += fetch_children(self)
    return descendants
  end

  private

  def fetch_children(module_result)
    descendants = []
    children = module_result.children
    unless children.empty?
      descendants += children
      children.each { | child | descendants += fetch_children(child) }
    end
    return descendants
  end

end
