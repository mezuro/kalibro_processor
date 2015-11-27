FactoryGirl.define do
  factory :metric_result, class: TreeMetricResult do
    metric_configuration { FactoryGirl.build(:metric_configuration, :with_id) }
    metric { FactoryGirl.build(:metric) }

    trait :with_id do
      sequence(:id, 1)
    end
  end
end