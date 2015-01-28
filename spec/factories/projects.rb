FactoryGirl.define do
  factory :project do
    name "QtCalculator"
    description "A simple calculator for us."

    trait :with_id do
      id 1
    end

    factory :project_with_id, traits: [:with_id]
  end
end