class KalibroModule < ActiveRecord::Base
  belongs_to :module_result # one for each MetricCollector

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
    if self.granularity.type == KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE
      return nil
    elsif self.name.length <= 1
      return KalibroModule.new({granularity: KalibroClient::Entities::Miscellaneous::Granularity.new(KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE), name: "ROOT"})
    else
      new_granularity = self.granularity.parent
      new_granularity = KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE if new_granularity.type == KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE # if the parent is not the ROOT, so, it should be a PACKAGE not a SOFTWARE
      return KalibroModule.new({granularity: new_granularity, name: self.name[0..-2]}) # 0..-2 creates a range from 0 to the element before the last element
    end
  end

  def granularity=(value)
    super(value.to_s)
  end

  def granularity
    KalibroClient::Entities::Miscellaneous::Granularity.new(super.to_sym)
  end

  def to_s
    self.short_name
  end
end
