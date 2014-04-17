FactoryGirl.define do
  factory :reading_group do
    name "My Reading Group"
    reading { FactoryGirl.build(:reading) }

    initialize_with { ReadingGroup.new(name, reading) }
  end
end
