FactoryGirl.define  do
  factory :metric, class: KalibroClient::Entities::Miscellaneous::Metric do
    name "Afferent Connections per Class (used to calculate COF - Coupling Factor)"
    code "acc"
    type 'TestMetricSnapshot'
    scope { { "type" => :SOFTWARE } }

    initialize_with { new(type, name, code, scope) }

    # Native metric base factories

    trait :native do
      type 'NativeMetricSnapshot'
      languages [:C]
    end

    factory :native_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric do
      native

      name "Native Metric"
      code "NM"
      description "A native metric"
      metric_collector_name 'NativeTestCollector'

      initialize_with { new(name, code, scope, languages, metric_collector_name) }
    end

    # Compound metric base factories

    trait :compound do
      type 'CompoundMetricSnapshot'
      script "return 2;"
    end

    factory :compound_metric, class: KalibroClient::Entities::Miscellaneous::CompoundMetric do
      compound

      name "Compound Metric"
      code "CM"
      scope { { "type" => :SOFTWARE } }
      description "A compound metric"

      initialize_with { new(name, code, scope, script) }
    end

    # Hotspot metric base factories

    trait :hotspot do
      type 'HotspotMetricSnapshot'
      scope { { "type" => "SOFTWARE" } }
      languages [:RUBY]
    end

    factory :hotspot_metric, class: KalibroClient::Entities::Miscellaneous::HotspotMetric do
      hotspot

      name "Hotspot Metric"
      code "HM"
      description "A hotspot metric"
      metric_collector_name 'HotspotTestCollector'

      initialize_with { new(name, code, languages, metric_collector_name) }
    end

    # Analizo factories

    trait :analizo do
      languages [:C, :CPP, :JAVA]
      metric_collector_name "Analizo"
    end

    factory :acc_metric, parent: :native_metric do
      analizo

      name "Afferent Connections per Class (used to calculate COF - Coupling Factor)"
      code "acc"
      scope { { "type" => :CLASS } }
    end

    factory :total_abstract_classes_metric, parent: :native_metric do
      analizo

      name "Total Abstract Classes"
      code "total_abstract_classes"
      scope { { "type" => :SOFTWARE } }
    end

    factory :loc_metric, parent: :native_metric do
      analizo

      name "Lines of Code"
      code "loc"
      scope { { "type" => "CLASS" } }
    end

    # MetricFu factories

    trait :metric_fu do
      languages [:RUBY]
      metric_collector_name "MetricFu"
      scope { { "type" => 'METHOD' } }
    end

    factory :flog_metric, parent: :native_metric do
      metric_fu

      name "Pain"
      code :flog
    end

    factory :saikuro_metric,  parent: :native_metric do
      metric_fu

      name "Cyclomatic Complexity"
      code 'saikuro'
    end

    factory :flay_metric, parent: :hotspot_metric do
      metric_fu

      name "Duplicate Code"
      code :flay
      scope { { "type" => "SOFTWARE" } }
    end


    factory :compound_flog_metric, parent: :compound_metric do
      script "return flog() * 2;"
    end

    factory :compound_saikuro_metric, parent: :compound_metric do
      script "return saikuro() * Math.sqrt(2);"
    end

    # Radon factories

    trait :radon do
      languages [:PYTHON]
      metric_collector_name "Radon"
      scope { { "type" => :METHOD } }
    end

    factory :cyclomatic_metric, parent: :native_metric do
      radon

      name "Cyclomatic Complexity"
      code 'cc'
    end

    factory :maintainability_metric, parent: :native_metric do
      radon

      name "Maintainability Index"
      code 'mi'
      scope { { "type" => :PACKAGE } }
    end

    factory :lines_of_code_metric, parent: :native_metric do
      radon

      name "Lines of code"
      code 'loc'
      scope { { "type" => :PACKAGE } }
    end

    factory :logical_lines_of_code_metric, parent: :native_metric do
      radon

      name "Logical lines of code"
      code 'lloc'
      scope { { "type" => :PACKAGE } }
    end

    trait :phpmd do
      languages [:PHP]
      metric_collector_name "CodeClimate PHPMD"
    end

    factory :phpmd_metric, parent: :hotspot_metric do
      phpmd

      name "Controversial/CamelCaseVariableName"
      code :ccvn
    end
  end
end
