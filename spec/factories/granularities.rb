FactoryGirl.define  do
  factory :granularity do
    type :SOFTWARE

    trait :with_software_type do
      type :SOFTWARE
    end

    trait :with_class_type do
      type :CLASS
    end

    trait :with_method_type do
      type :METHOD
    end

    factory :software_granularity, traits: [:with_software_type]
    factory :class_granularity, traits: [:with_class_type]
    factory :method_granularity, traits: [:with_method_type]

    initialize_with { Granularity.new(type) }
  end
end
