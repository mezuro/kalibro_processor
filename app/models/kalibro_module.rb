class KalibroModule
  attr_accessor :granularity
  attr_reader :name

  def initialize(granularity, name)
    @granularity = granularity
    @name = name
  end

  def short_name
    name.last
  end

  def long_name
    name.join('.')
  end

  def parent
    return nil if self.granularity.type == Granularity::SOFTWARE
    return KalibroModule.new(Granularity.new(Granularity::SOFTWARE), "ROOT") if self.name.length <= 1
    return KalibroModule.new(self.granularity.parent, self.name[0..-2]) # 0..-2 creates a range from 0 to the element before the last element
  end

  def to_s
    self.short_name
  end
end