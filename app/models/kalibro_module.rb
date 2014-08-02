class KalibroModule < ActiveRecord::Base
  has_many :module_results # one for each MetricCollector

  def name=(value)
    self.long_name = value
    self.long_name = value.join('.') if value.is_a?(Array)
  end

  def name
    self.long_name.split('.')
  end

  def short_name
    name.last
  end

  def parent
    if self.granularity.type == Granularity::SOFTWARE
      return nil
    elsif self.name.length <= 1
      return KalibroModule.new({granularity: Granularity.new(Granularity::SOFTWARE), name: "ROOT"})
    else
      new_granularity = self.granularity.parent
      new_granularity = Granularity::PACKAGE if new_granularity.type == Granularity::SOFTWARE # if the parent is not the ROOT, so, it should be a PACKAGE not a SOFTWARE
      return KalibroModule.new({granularity: new_granularity, name: self.name[0..-2]}) # 0..-2 creates a range from 0 to the element before the last element
    end
  end

  def granularity=(value)
    self.granlrty = value.to_s
  end

  def granularity
    Granularity.new(self.granlrty.to_sym)
  end

  def to_s
    self.short_name
  end
end