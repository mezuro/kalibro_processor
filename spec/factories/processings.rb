FactoryGirl.define do
  factory :processing do
    created_at "2011-10-20T18:26:43.151+00:00"
    updated_at "2011-10-20T18:26:43.151+00:00"
    state "READY"
    module_results { [] }

    association :repository, factory: :repository, strategy: :build

    trait :error do
      error_message "ERROR message"
    end

    trait :periodic do
      repository { FactoryGirl.build(:repository, period: 2) }
    end

    trait :with_id do
      sequence(:id, 1)
    end

    factory :processing_with_error, traits: [:error]
    factory :periodic_processing, traits: [:periodic]
  end
end
