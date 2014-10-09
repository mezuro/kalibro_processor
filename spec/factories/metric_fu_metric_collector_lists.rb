class MetricFuMetricCollectorLists
  attr_accessor :flog_results
end

FactoryGirl.define do
  factory :metric_fu_metric_collector_lists, class: MetricFuMetricCollectorLists do
    flog_results { {:flog => {:method_containers => [{:path => "app/models/repository.rb",
                   :methods => {"Repository#process"=>{:operators=>{:perform_later=>1.1}, :score=>1.1, :path=>"app/models/repository.rb:30"}}}]}} }
  end
end