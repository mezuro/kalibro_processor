FactoryGirl.define do
  factory :kalibro_range do
    beginning 1.1
    self.end 5.1
    reading { FactoryGirl.build(:reading) }

    initialize_with { KalibroRange.new(beginning, self.end, reading) }
  end
end
