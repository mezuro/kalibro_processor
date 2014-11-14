# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :process_time do
    id 100
    state "MyString"
    created_at "2014-07-31T08:58:07+00:00"
    updated_at "2014-07-31T09:12:01+00:00"
  end
end
