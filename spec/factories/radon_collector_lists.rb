class RadonMetricCollectorLists
  attr_accessor :results
end

FactoryGirl.define do
  factory :radon_collector_lists, class: MetricFuMetricCollectorLists do
    results {{:mi => {"app/models/repository.py" => {"mi" => 100.0, "rank" => "A"}},
    :raw => { "app/models/repository.py" => {"loc" => 14, "lloc" => 10, "sloc" => 11, "multi" => 0, "comments" => 1, "blank" => 3} },
    :cc => { "app/models/repository.py" => [{"name"=> "Client","complexity" => 1}],
      "app/models/class.py" => [{"name"=> "Class","complexity" => 1}]}
    }
  }
  end
end
