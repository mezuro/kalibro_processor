class ModuleResult
  attr_reader :id, :height, :parent, :kalibro_module
  attr_accessor :grade, :children, :metric_results

  def initialize(parent, kalibro_module)
    @height = 0
    @parent = parent
    @children = []
    @kalibro_module = kalibro_module
    @metric_results = []
  end
end
