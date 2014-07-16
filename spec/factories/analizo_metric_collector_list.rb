class AnalizoMetricCollectorList
  attr_accessor :raw, :parsed, :raw_result, :parsed_result, :version
end

FactoryGirl.define do
  factory :analizo_metric_collector_list, class: AnalizoMetricCollectorList do
    raw "Global Metrics:\ntotal_abstract_classes - Total Abstract Classes\nModule Metrics:\nacc - Afferent Connections per Class (used to calculate COF - Coupling Factor)"
    parsed {{"total_abstract_classes" =>
              FactoryGirl.build(:analizo_native_metric, name: "Total Abstract Classes", description: ""),
            "acc" =>
              FactoryGirl.build(:analizo_native_metric, name: "Afferent Connections per Class (used to calculate COF - Coupling Factor)", description: "", scope: :CLASS)
           }}
    raw_result "---\nuav_variance: 0\n---\n_filename:\n  - Class.rb\n_module: My::Software::Module\nacc: 0"
    parsed_result { [{"uav_variance"=>0}, {"_filename"=>["Class.rb"], "_module"=>"My::Software::Module", "acc"=>0}] }
    version "analizo version 1.16.0\n"
  end
end