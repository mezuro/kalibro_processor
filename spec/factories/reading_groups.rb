FactoryGirl.define do
  factory :reading_group, class: KalibroClient::Entities::Configurations::ReadingGroup do
    id 1
    name "Mussum"
    description "Cacildis!"
  end
end
