class ModuleResult
  attr_reader :id, :height, :kalibro_module
  attr_accessor :grade, :children, :metric_results, :parent

  def initialize(parent, kalibro_module)
    @height = 0
    @parent = parent
    @children = []
    @kalibro_module = kalibro_module
    @metric_results = []
  end

  def children
    @children.map do |child|
      child.parent = self
      child
    end
  end

  def metric_result_for(metric)
    metric_results.each {|metric_result| return metric_result if metric_result.metric == metric}
    return nil
  end
end
