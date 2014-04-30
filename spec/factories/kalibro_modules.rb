FactoryGirl.define do
  factory :kalibro_module do
    granularity { FactoryGirl.build(:granularity) }
    name { ['home', 'user', 'project']}

    initialize_with { KalibroModule.new({granularity: granularity, name: name}) }
  end
end
