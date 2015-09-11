class MetricFuMetricCollectorLists
  attr_accessor :results
end

FactoryGirl.define do
  factory :metric_fu_metric_collector_lists, class: MetricFuMetricCollectorLists do
    results { {
      :flog => {
        :method_containers => [
          {:path => "app/models/repository.rb",
           :methods => {
             "Repository#process"=>{
               :operators => {:perform_later=>1.1},
               :score => 1.1,
               :path => "app/models/repository.rb:30"},
             "Repository#reprocess"=>{
               :operators => {:perform_later=>1.1},
               :score => 2.0,
               :path => "app/models/repository.rb:30"},
             "main#none" => {
               :operators=>{:require=>36.20000000000003},
               :score=>3.0,
               :path => nil}
            }
          }
        ]
      },
      :saikuro => {
        :files => [
          { :filename => "app/models/repository.rb",
            :classes => [
              { :class_name => "Repository",
                :methods => [
                  { :name => "Repository#reprocess",
                    :complexity => 5,
                    :lines => 10},
                  { :name => "Repository#process",
                    :complexity => 10,
                    :lines => 20
                  }
                ]
              }
            ]
          }
        ]
      },
      :flay => {
        :total_score => '599',
        :matches => [
          { :reason => "1) Similar code found in :module (mass = 154)",
            :matches => [
              { :name => "lib/metric_collector/native/metric_fu/parser/flay.rb", :line => '38' },
              { :name => "lib/metric_collector/native/metric_fu/parser/flog.rb", :line => '38' }
            ]
          },
          { :reason => "6) IDENTICAL code found in :defn (mass*2 = 64)",
            :matches => [
              { :name => "app/controllers/processings_controller.rb", :line => '63' },
              { :name => "app/controllers/repositories_controller.rb", :line => '63' },
              { :name => "lib/metric_collector/native/metric_fu/parser/saikuro.rb", :line => '63' }
            ]
          }
        ]
      }
    } }
  end
end
