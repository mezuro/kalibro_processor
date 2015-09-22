FactoryGirl.define do
  factory :hotspot_metric_result do
    line_number 1
    message "1) Similar code found in :module (mass = 154)"

    metric_configuration { FactoryGirl.build(:hotspot_metric_configuration) }
    value nil

    trait :with_id do
      sequence(:id, 1)
    end
  end
end
