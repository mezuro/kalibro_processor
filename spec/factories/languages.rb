FactoryGirl.define do
  factory :language do
    type :C

    initialize_with { Language.new(type) }
  end
end
