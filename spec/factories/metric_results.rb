FactoryGirl.define do
  factory :metric_result do
    metric { FactoryGirl.build(:metric) }
    metric_configuration Hash.new(aggregation_form: :AVERAGE)
    value 1.1
    error nil
    descendant_results [1, 2, 3]
  end
end
