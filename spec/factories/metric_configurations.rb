FactoryGirl.define do
  factory :metric_configuration do
    metric { FactoryGirl.build(:metric) }
    base_tool { FactoryGirl.build(:base_tool) }
    aggregation_form :COUNT
    reading_group { FactoryGirl.build(:reading_group) }
    range { FactoryGirl.build(:range) }

    initialize_with { MetricConfiguration.new(metric, base_tool, aggregation_form, range) }
  end
end
