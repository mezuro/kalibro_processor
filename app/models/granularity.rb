class Granularity
  GRANULARITIES = [:METHOD, :CLASS, :PACKAGE, :SOFTWARE]

  METHOD = GRANULARITIES[0]
  CLASS = GRANULARITIES[1]
  PACKAGE = GRANULARITIES[2]
  SOFTWARE = GRANULARITIES[3]

  attr_reader :type

  def initialize(type)
    if GRANULARITIES.include?(type)
      @type = type
    else
      raise TypeError.new("Not supported granularity type #{type}")
    end
  end

  def parent
    return self if self.type == SOFTWARE
    return Granularity.new(GRANULARITIES[GRANULARITIES.find_index(self.type) + 1])
  end

  def to_s
    self.type.to_s
  end

  def <(other_granularity)
    GRANULARITIES.find_index(self.type) < GRANULARITIES.find_index(other_granularity.type)
  end

  def ==(other_granularity)
    self.type == other_granularity.type
  end
  
  
  def <=(other_granularity)
    (self < other_granularity) || (self == other_granularity)
  end

  def >=(other_granularity)
    (self > other_granularity) || (self == other_granularity)
  end

  def >(other_granularity)
    !(self <= other_granularity)
  end
end
