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

    factory :module_result_class_granularity, traits: [:class]
    initialize_with { ModuleResult.new({parent: parent, kalibro_module: kalibro_module}) }
  end
end
