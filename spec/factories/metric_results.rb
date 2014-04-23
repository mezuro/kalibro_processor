FactoryGirl.define do
  factory :metric_result do
    metric_configuration Hash.new(aggregation_form: :AVERAGE)
    value nil
    descendant_results [1, 2, 3]

    initialize_with { MetricResult.new(metric_configuration, value) }
  end
end
