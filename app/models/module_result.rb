class ModuleResult < ActiveRecord::Base
  has_one :kalibro_module, dependent: :destroy #It can go wrong if someday we want to destroy only module results and not the whole processing
  has_many :children, foreign_key: 'parent_id', class_name: 'ModuleResult', dependent: :destroy
  has_many :metric_results, dependent: :destroy
  has_many :hotspot_results, class_name: 'HotspotResult', dependent: :destroy

  belongs_to :parent, class_name: 'ModuleResult'
  belongs_to :processing

  attr_reader :pre_order

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

  def pre_order
    root = self
    root = root.parent until root.parent==nil
    @pre_order ||= pre_order_traverse(root)
  end

  private

  def pre_order_traverse(module_result)
    pre_order_array = [module_result]
    children = module_result.children
    unless children.empty?
      children.each { |child| pre_order_array += pre_order_traverse(child) }
    end
    pre_order_array
  end
end
