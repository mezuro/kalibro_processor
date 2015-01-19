FactoryGirl.define  do
  factory :metric, class: KalibroClient::Entities::Miscellaneous::Metric do
    name "Afferent Connections per Class (used to calculate COF - Coupling Factor)"
    code "acc"
    type 'NativeMetricSnapshot'
    scope { :SOFTWARE }

    initialize_with { KalibroClient::Entities::Miscellaneous::Metric.new(type, name, code, scope) }
  end

  factory :analizo_native_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :metric do
    languages { [:C, :CPP, :JAVA] }
    metric_collector_name "Analizo"

    initialize_with { KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, languages, metric_collector_name) }
  end
  
  
  factory :compound_metric, class: KalibroClient::Entities::Miscellaneous::CompoundMetric, traits: [:compound] do
    name "Compound Metric"
    code "CM"
    scope { :SOFTWARE }
    description "A compound metric"
    type 'NativeMetricSnapshot'
    
    initialize_with { KalibroClient::Entities::Miscellaneous::CompoundMetric.new(name, code, scope, script) }
  end


  factory :loc, class: KalibroClient::Entities::Miscellaneous::NativeMetric, traits: [:loc] do
    initialize_with { KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, languages, metric_collector_name) }
  end

  trait :compound do
    type 'CompoundMetricSnapshot'
    script "return 2;"
  end

  trait :loc do
    name "Lines of Code"
    type 'NativeMetricSnapshot'
    code "loc"
    scope "CLASS"
    metric_collector_name "Analizo"
    description nil
    languages { [:C] }
  end
end
