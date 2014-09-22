class Granularity
  GRANULARITIES = [:SOFTWARE, :PACKAGE, :CLASS, :METHOD]

  SOFTWARE = GRANULARITIES[0]
  PACKAGE = GRANULARITIES[1]
  CLASS = GRANULARITIES[2]
  METHOD = GRANULARITIES[3]

  attr_reader :type

  def initialize(type)
    if self.class.is_valid?(type)
      @type = type
    else
      raise TypeError.new("Not supported granularity type #{type}")
    end
  end

  def parent
    return self if self.type == SOFTWARE
    return Granularity.new(GRANULARITIES[GRANULARITIES.find_index(self.type) - 1])
  end

  def to_s
    self.type.to_s
  end

  def self.is_valid?(type)
    GRANULARITIES.include?(type)
  end
  
  def <(other_granularity)
    self.type != other_granularity.type && self <= other_granularity
  end

  def >(other_granularity)
    !(self.type <= other_granularity.type)
  end

  def <=(other_granularity)
    GRANULARITIES.find_index(self.type) >= GRANULARITIES.find_index(other_granularity.type)
  end

end
