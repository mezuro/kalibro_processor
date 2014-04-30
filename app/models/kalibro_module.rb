class KalibroModule < ActiveRecord::Base
  belongs_to :module_result

  def short_name
    name.last
  end

  def long_name
    name.join('.')
  end

  def parent
    return nil if self.granularity.type == Granularity::SOFTWARE
    return KalibroModule.new({granularity: Granularity.new(Granularity::SOFTWARE), name: "ROOT"}) if self.name.length <= 1
    return KalibroModule.new({granularity: self.granularity.parent, name: self.name[0..-2]}) # 0..-2 creates a range from 0 to the element before the last element
  end

  def to_s
    self.short_name
  end
end