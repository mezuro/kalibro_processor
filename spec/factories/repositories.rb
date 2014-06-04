# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repository do
    name "MyString"
    type ""
    address ""
    description "MyString"
    license "MyString"
    period 1
  end
end
