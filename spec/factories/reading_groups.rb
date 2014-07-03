FactoryGirl.define do
  factory :reading_group, class: KalibroGatekeeperClient::Entities::ReadingGroup do
    id 1
    name "Mussum"
    description "Cacildis!"
  end
end
