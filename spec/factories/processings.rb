FactoryGirl.define do
  factory :processing do
    id "31"
    created_at "2011-10-20T18:26:43.151+00:00"
    updated_at "2011-10-20T18:26:43.151+00:00"
    state "READY"
    process_times {[FactoryGirl.build(:process_time)]}
    root_module_result_id 13
    repository { FactoryGirl.build(:repository) }
    module_results { [] }

    trait :error do
      error_message "ERROR message"
    end

    trait :periodic do
      repository { FactoryGirl.build(:repository, period: 2) }
    end

    factory :processing_with_error, traits: [:error]
    factory :periodic_processing, traits: [:periodic]
  end
end
