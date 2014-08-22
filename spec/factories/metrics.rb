FactoryGirl.define  do
  factory :metric do
    compound false
    name "Total Abstract Classes"
    code "total_abstract_classes"
    scope { :SOFTWARE }
    description "Total Abstract Classes"

    initialize_with { Metric.new(compound, name, code, scope) }
  end

  factory :analizo_native_metric, class: NativeMetric, parent: :metric do
    languages { [:C, :CPP, :JAVA] }

    initialize_with { NativeMetric.new(name, code, scope, languages) }
  end
end