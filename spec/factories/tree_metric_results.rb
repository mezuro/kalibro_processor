FactoryGirl.define do
  factory :tree_metric_result, class: TreeMetricResult do
    metric_configuration { FactoryGirl.build(:metric_configuration, :with_id) }
    value nil
    metric { FactoryGirl.build(:metric) }

    trait :with_value do
      value 2.0
    end

    trait :with_id do
      sequence(:id, 1)
    end

    factory :tree_metric_result_with_value, traits: [:with_value]
  end
end
