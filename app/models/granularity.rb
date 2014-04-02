class Granularity
  GRANULARITIES = [:SOFTWARE, :PACKAGE, :CLASS, :METHOD]

  attr_reader :type

  def initialize(type)
    if self.class.is_valid?(type)
      @type = type
    else
      raise TypeError.new("Not supported granularity type #{type}")
    end
  end

  def self.is_valid?(type)
    GRANULARITIES.include?(type)
  end
end