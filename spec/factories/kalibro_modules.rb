FactoryGirl.define do
  factory :kalibro_module do
    granularity { FactoryGirl.build(:granularity) }
    name { ['home', 'user', 'project'] }

    trait :with_id do
      sequence(:id, 1)
    end

    trait :with_granularity_software do
      granularity { FactoryGirl.build(:software_granularity) }
    end

    trait :with_granularity_package do
      granularity { FactoryGirl.build(:package_granularity) }
    end

    trait :with_granularity_class do
      granularity { FactoryGirl.build(:class_granularity) }
    end

    trait :with_granularity_method do
      granularity { FactoryGirl.build(:method_granularity) }
    end

    trait :with_granularity_function do
      granularity { FactoryGirl.build(:function_granularity) }
    end

    factory :kalibro_module_with_software_granularity, traits: [:with_granularity_software]
    factory :kalibro_module_with_package_granularity, traits: [:with_granularity_package]
    factory :kalibro_module_with_class_granularity, traits: [:with_granularity_class]
    factory :kalibro_module_with_method_granularity, traits: [:with_granularity_method]
    factory :kalibro_module_with_function_granularity, traits: [:with_granularity_function]

    initialize_with { KalibroModule.new({granularity: granularity, name: name}) }

    factory :kalibro_module_with_id, traits: [:with_id]
  end
end
