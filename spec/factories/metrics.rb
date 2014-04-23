FactoryGirl.define  do
  factory :metric do
    compound false
    name "Total Abstract Classes"
    scope { FactoryGirl.build(:granularity) }
    description "Total Abstract Classes"

    initialize_with { Metric.new(compound, name, scope) }
  end

  factory :native_metric, class: NativeMetric, parent: :metric do
    languages { FactoryGirl.build(:language) }

    initialize_with { NativeMetric.new(name, scope, languages) }
  end
end