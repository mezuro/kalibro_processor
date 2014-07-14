FactoryGirl.define  do
  factory :base_tool do
    name "Analizo"
    description "C/C++ and Java metrics"
    collector_class_name "AnalizoMetricCollector"
    supported_metrics { [FactoryGirl.build(:analizo_native_metric)] }

    initialize_with { BaseTool.new(name, description, collector_class_name, supported_metrics) }
  end
end