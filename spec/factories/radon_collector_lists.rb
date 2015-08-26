class RadonMetricCollectorLists
  attr_accessor :results
end

FactoryGirl.define do
  factory :radon_collector_lists, class: RadonMetricCollectorLists do
    results {
      {
        :mi => {
          "app/models/repository.py" => {"mi" => 100.0, "rank" => "A"}
        },
        :raw => {
          "app/models/repository.py" => {
            "loc" => 14,
            "lloc" => 10,
            "sloc" => 11,
            "multi" => 0,
            "comments" => 1,
            "blank" => 3
          }
        },
        :cc => {
          "app/models/repository.py" => [{
            "name" => "Client",
            "type" => "class",
            "methods" => [
              {"name" => "method1", "complexity" => 1.0},
              {"name" => "method2", "complexity" => 5.0}
            ]
          },
          {
            "name" => "setUp",
            "type" => "method",
            "classname" => "Class",
            "complexity" => 2
          },
          {
            "name" => "callFunction",
            "type" => "function",
            "complexity" => 3
          }],
          "Rakefile" => {
            "error" => "invalid syntax (<unknown>, line 4)"
          }
        }
      }
    }
  end
end
