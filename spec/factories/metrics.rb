FactoryGirl.define  do
  factory :metric, class: KalibroClient::Miscellaneous::Metric do
    compound false
    name "Afferent Connections per Class (used to calculate COF - Coupling Factor)"
    code "acc"
    scope { :SOFTWARE }
    description "Afferent Connections per Class (used to calculate COF - Coupling Factor)"

    initialize_with { KalibroClient::Miscellaneous::Metric.new(compound, name, code, scope) }
  end

  factory :analizo_native_metric, class: KalibroClient::Miscellaneous::NativeMetric, parent: :metric do
    languages { [:C, :CPP, :JAVA] }

    initialize_with { KalibroClient::Miscellaneous::NativeMetric.new(name, code, scope, languages) }
  end
  
  
  factory :compound_metric, class: KalibroClient::Miscellaneous::CompoundMetric, traits: [:compound] do
    name "Compound Metric"
    code "CM"
    scope { :SOFTWARE }
    description "A compound metric"
    
    initialize_with { KalibroClient::Miscellaneous::CompoundMetric.new(name, code, scope, script) }
  end


  factory :loc, class: KalibroClient::Miscellaneous::NativeMetric, traits: [:loc] do
    initialize_with { KalibroClient::Miscellaneous::NativeMetric.new(name, code, scope, languages) }
  end

  trait :compound do
    compound true
    script "return 2;"
  end

  trait :loc do
    name "Lines of Code"
    code "loc"
    scope "CLASS"
    description nil
    languages { [:C] }
  end
end
