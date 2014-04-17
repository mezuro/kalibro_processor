FactoryGirl.define do
  factory :reading do
    label "Average"

    initialize_with { Reading.new(label) }
  end
end
