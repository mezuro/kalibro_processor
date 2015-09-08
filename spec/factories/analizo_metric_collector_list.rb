class AnalizoMetricCollectorList
  attr_accessor :raw, :parsed, :raw_result, :parsed_result, :version
end

FactoryGirl.define do
  factory :analizo_metric_collector_list, class: AnalizoMetricCollectorList do
    raw <<-EOF
Global Metrics:
total_abstract_classes - Total Abstract Classes
Module Metrics:
acc - Afferent Connections per Class (used to calculate COF - Coupling Factor)
EOF
    parsed {
      {
        "total_abstract_classes" => FactoryGirl.build(:total_abstract_classes_metric),
        "acc" => FactoryGirl.build(:acc_metric)
      }
    }

    raw_result <<-YAML
---
total_abstract_classes: 10
---
_filename:
  - Class.rb
_module: My::Software::Module
acc: 0
YAML
    parsed_result {
      [
        {"total_abstract_classes" => 10},
        {"_filename" => ["Class.rb"], "_module" => "My::Software::Module", "acc" => 0}
      ]
    }
    version "analizo version 1.16.0\n"
  end
end
