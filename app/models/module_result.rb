class ModuleResult
  attr_reader :id, :grade, :height, :parent
  attr_accessor :children

  def initialize(id, grade, height, parent, children)
    @id = id
    @grade = grade
    @height = height
    @parent = parent
    @children = children
  end

  def has_parent?
    @parent != nil
  end

end