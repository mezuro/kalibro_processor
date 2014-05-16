FactoryGirl.define  do
  factory :granularity do
    type :SOFTWARE
    
    trait :with_class_type do
      type :CLASS
    end

    factory :class_granularity, traits: [:with_class_type]

    initialize_with { Granularity.new(type) }
  end
end