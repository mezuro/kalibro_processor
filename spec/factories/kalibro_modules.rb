FactoryGirl.define do
  factory :kalibro_module do
    granularity { FactoryGirl.build(:granularity) }
    name { ['home', 'user', 'project'] }

    trait :with_id do
      id 51
    end

    initialize_with { KalibroModule.new({granularity: granularity, name: name}) }

    factory :kalibro_module_with_id, traits: [:with_id]
  end
end
