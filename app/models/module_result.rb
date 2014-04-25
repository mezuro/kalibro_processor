class ModuleResult
  attr_reader :id, :grade, :height, :parent, :kalibro_module
  attr_accessor :children, :metric_results

  def initialize(id, grade, height, parent, children, kalibro_module)
    @id = id
    @grade = grade
    @height = height
    @parent = parent
    @children = children
    @kalibro_module = kalibro_module
    @metric_configuration = KalibroGatekeeperClient::Entities::MetricConfiguration.new
    @metric_results = [MetricResult.new(metric_configuration, value, nil)]
  end

  def has_parent?
    @parent != nil
  end
end