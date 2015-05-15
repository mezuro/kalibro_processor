class MetricFuMetricCollectorLists
  attr_accessor :results
end

FactoryGirl.define do
  factory :metric_fu_metric_collector_lists, class: MetricFuMetricCollectorLists do
    results { {:flog => {:method_containers => [{:path => "app/models/repository.rb",
                   :methods => {"Repository#process"=>{:operators=>{:perform_later=>1.1}, :score=>1.1, :path=>"app/models/repository.rb:30"},
                                "Repository#reprocess"=>{:operators=>{:perform_later=>1.1}, :score=>2.0, :path=>"app/models/repository.rb:30"},
                                "main#none"=>{:operators=>{:require=>36.20000000000003}, :score=>3.0, :path=>nil}}}]},
    :saikuro =>
      {
        :files => [
          {
            :filename => "app/models/repository.rb",
            :classes => [
              {
                :class_name => "Repository",
                :methods => [
                  {
                    :name => "Repository#reprocess",
                    :complexity => 5,
                    :lines => 10},
                  {
                    :name => "Repository#process",
                    :complexity => 10,
                    :lines => 20
                  }
                ]
              }
            ]
          }
        ]
      }
    }
  }
  end
end
