FactoryGirl.define  do
  factory :metric do
    compound false
    name "Afferent Connections per Class (used to calculate COF - Coupling Factor)"
    code "acc"
    scope { :SOFTWARE }
    description "Afferent Connections per Class (used to calculate COF - Coupling Factor)"

    initialize_with { Metric.new(compound, name, code, scope) }
  end

  factory :analizo_native_metric, class: NativeMetric, parent: :metric do
    languages { [:C, :CPP, :JAVA] }

    initialize_with { NativeMetric.new(name, code, scope, languages) }
  end
end