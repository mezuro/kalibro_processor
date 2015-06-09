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
    type 'CompoundMetricSnapshot'

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

  factory :flog_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :metric do
    languages { [:RUBY] }
    scope { :METHOD }
    metric_collector_name "MetricFu"
    code 'flog'

    initialize_with { KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, languages, metric_collector_name) }
  end

  factory :saikuro_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :metric do
    name "Cyclomatic Complexity"
    languages { [:RUBY] }
    scope { :METHOD }
    metric_collector_name "MetricFu"
    code 'saikuro'

    initialize_with { KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, languages, metric_collector_name) }
  end

  factory :cyclomatic_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :metric do
    name "Cyclomatic Complexity"
    languages { [:PYTHON] }
    scope { :METHOD }
    metric_collector_name "Radon"
    code 'cc'

    initialize_with { KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, languages, metric_collector_name) }
  end

  factory :maintainability_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :metric do
    name "Maintainability Index"
    languages { [:PYTHON] }
    scope { :METHOD }
    metric_collector_name "Radon"
    code 'mi'

    initialize_with { KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, languages, metric_collector_name) }
  end

  factory :lines_of_code_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :metric do
    name "Lines of code"
    languages { [:PYTHON] }
    scope { :METHOD }
    metric_collector_name "Radon"
    code 'loc'    

    initialize_with { KalibroClient::Entities::Miscellaneous::NativeMetric.new(name, code, scope, languages, metric_collector_name) }
  end    

  factory :compound_flog_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :compound_metric do
    script "return flog() * 2;"
  end

  factory :compound_saikuro_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric, parent: :compound_metric do
    script "return saikuro() * Math.sqrt(2);"
  end
end
