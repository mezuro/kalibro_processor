require 'rails_helper'

describe Processor::Aggregator do
  describe 'methods' do
    describe 'aggregate' do
      let!(:root_module_result) { FactoryGirl.build(:module_result) }
      let!(:child) { FactoryGirl.build(:module_result_class_granularity, parent: root_module_result) }
      let!(:native_metric_configurations) {
        [FactoryGirl.build(:metric_configuration, id: 1),
          FactoryGirl.build(:metric_configuration, metric: FactoryGirl.build(:kalibro_gatekeeper_client_loc), id: 2)]
      }
      let!(:compound_metric_configurations) { [FactoryGirl.build(:compound_metric_configuration)] }
      let!(:native_metrics) { { "Analizo" => native_metric_configurations } }
      let!(:all_metrics) { [native_metric_configurations.first.metric, native_metric_configurations.last.metric] }

      context 'when the module result tree has been well-built' do

        before :each do
          root_module_result.expects(:subtree_elements).returns([root_module_result, child])
          MetricResult.any_instance.expects(:aggregated_value).times(4)
          MetricResult.any_instance.expects(:save).times(4)
        end

        it 'is expected to aggregate results' do
          Processor::Aggregator.aggregate(root_module_result, native_metrics)
        end
      end
    end
  end
end
