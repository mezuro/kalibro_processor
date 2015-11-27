FactoryGirl.define do
  factory :module_result do
    kalibro_module { FactoryGirl.build(:kalibro_module) }
    parent nil
    grade 10.0
    tree_metric_results { [FactoryGirl.build(:tree_metric_result)] }
    hotspot_metric_results { [FactoryGirl.build(:hotspot_metric_result)] }
    processing { FactoryGirl.build(:processing, :with_id) }

    trait :class do
      kalibro_module { FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:class_granularity)) }
    end

    trait :package do
      kalibro_module { FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:package_granularity)) }
    end

    trait :software do
      kalibro_module { FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:software_granularity)) }
    end

    trait :with_id do
      id 14
    end

    trait :kalibro_module_with_id do
      kalibro_module { FactoryGirl.build(:kalibro_module_with_id) }
    end

    factory :module_result_class_granularity, traits: [:class]
    factory :module_result_with_id, traits: [:with_id]
    factory :module_result_with_kalibro_module_with_id, traits: [:kalibro_module_with_id]
    initialize_with { ModuleResult.new({parent: parent, kalibro_module: kalibro_module}) }
  end
end
