FactoryGirl.define do
  factory :process_time do
    sequence(:id, 1)
    state "MyString"
    created_at "2014-07-31T08:58:07+00:00"
    updated_at "2014-07-31T09:12:01+00:00"
  end
end
