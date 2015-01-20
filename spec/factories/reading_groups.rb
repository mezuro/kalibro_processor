FactoryGirl.define do
  factory :reading_group, class: KalibroClient::Entities::Configurations::ReadingGroup do
    name "Mussum"
    description "Cacildis!"

    trait :with_id do
      id 1
    end

    factory :reading_group_with_id, traits: [:with_id]
  end
end
