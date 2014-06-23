FactoryGirl.define do
  factory :processing do
    id "31"
    created_at "2011-10-20T18:26:43.151+00:00"
    state "READY"
    process_time {[FactoryGirl.build(:process_time)]}
    results_root_id "13"
    repository { FactoryGirl.build(:repository) }
  end
end