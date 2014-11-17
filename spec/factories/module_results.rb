FactoryGirl.define do
  factory :module_result do
    kalibro_module { FactoryGirl.build(:kalibro_module) }
    parent nil
    grade 10.0
    height 0
    metric_results { [FactoryGirl.build(:metric_result)] }

    trait :class do
      kalibro_module { FactoryGirl.build(:kalibro_module, granularity: FactoryGirl.build(:class_granularity)) }
    end

    trait :kalibro_module_with_id do
      kalibro_module { FactoryGirl.build(:kalibro_module_with_id) }
    end

    factory :module_result_class_granularity, traits: [:class]
    factory :module_result_with_kalibro_module_with_id, traits: [:kalibro_module_with_id]
    initialize_with { ModuleResult.new({parent: parent, kalibro_module: kalibro_module}) }
  end
end
