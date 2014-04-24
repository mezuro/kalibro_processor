FactoryGirl.define do
  factory :metric_result do
    metric_configuration { FactoryGirl.build(:metric_configuration) }
    value nil
    descendant_results [1, 2, 3]

    trait :with_value do
      value 2.0
    end

    factory :metric_result_with_value, traits: [:with_value]

    initialize_with { MetricResult.new(metric_configuration, value) }
  end
end
