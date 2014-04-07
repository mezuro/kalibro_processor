FactoryGirl.define  do
  factory :granularity do
    type :SOFTWARE

    initialize_with { Granularity.new(type) }
  end
end