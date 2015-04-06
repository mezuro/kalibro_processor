FactoryGirl.define  do
  factory :granularity do
    type :SOFTWARE
    
    trait :with_class_type do
      type :CLASS
    end

    trait :with_method_type do
      type :METHOD
    end

    factory :class_granularity, traits: [:with_class_type]
    factory :method_granularity, traits: [:with_method_type]

    initialize_with { Granularity.new(type) }
  end
end
