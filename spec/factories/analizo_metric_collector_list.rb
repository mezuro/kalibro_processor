class AnalizoMetricCollectorList
  attr_accessor :raw, :parsed
end

FactoryGirl.define do
  factory :analizo_metric_collector_list, class: AnalizoMetricCollectorList do
    raw "Global Metrics:\ntotal_abstract_classes - Total Abstract Classes\nModule Metrics:\nacc - Afferent Connections per Class (used to calculate COF - Coupling Factor)"
    parsed {{"total_abstract_classes" =>
              FactoryGirl.build(:analizo_native_metric, name: "Total Abstract Classes", description: ""),
            "acc" =>
              FactoryGirl.build(:analizo_native_metric, name: "Afferent Connections per Class (used to calculate COF - Coupling Factor)", description: "", scope: :CLASS)
           }}
  end
end