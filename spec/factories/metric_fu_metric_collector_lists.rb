class MetricFuMetricCollectorLists
  attr_accessor :flog_results
end

FactoryGirl.define do
  factory :metric_fu_metric_collector_lists, class: MetricFuMetricCollectorLists do
    flog_results { {:flog => {:method_containers => [{:path => "app/models/repository.rb",
                   :methods => {"Repository#process"=>{:operators=>{:perform_later=>1.1}, :score=>1.1, :path=>"app/models/repository.rb:30"}, 
                                "main#none"=>{:operators=>{:require=>36.20000000000003}, :score=>2.0, :path=>nil}}}]}} }
  end
end
