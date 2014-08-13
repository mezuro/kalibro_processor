require 'rails_helper'

describe Processor::Aggregator do
  describe 'methods' do
    describe 'aggregate' do
      let!(:root_module_result) { FactoryGirl.build(:module_result) }
      let!(:module_result) { FactoryGirl.build(:module_result_class_granularity, parent: root_module_result) }
      let!(:native_metric_configurations) {
        [FactoryGirl.build(:metric_configuration, id: 1),
          FactoryGirl.build(:metric_configuration, metric: FactoryGirl.build(:kalibro_gatekeeper_client_loc), id: 2)]
      }
      let!(:compound_metric_configurations) { [FactoryGirl.build(:compound_metric_configuration)] }
      let!(:native_metrics) { { "Analizo" => native_metric_configurations } }
      let!(:all_metrics) { [native_metric_configurations.first.metric, native_metric_configurations.last.metric] }
      let!(:metric_result) { FactoryGirl.build(:metric_result_with_value) }

      context 'when the module result tree has been well-built' do

        before :each do
          module_result.expects(:children).returns([])
          root_module_result.expects(:children).returns([module_result])
          MetricResult.expects(:new).with(metric: all_metrics.first, module_result: module_result, metric_configuration_id: native_metric_configurations.first.id).returns(metric_result)
          MetricResult.expects(:new).with(metric: all_metrics.last, module_result: module_result, metric_configuration_id: native_metric_configurations.last.id).returns(metric_result)
          MetricResult.expects(:new).with(metric: all_metrics.first, module_result: root_module_result, metric_configuration_id: native_metric_configurations.first.id).returns(metric_result)
          MetricResult.expects(:new).with(metric: all_metrics.last, module_result: root_module_result, metric_configuration_id: native_metric_configurations.last.id).returns(metric_result)
          metric_result.expects(:aggregated_value).times(4)
          metric_result.expects(:save).times(4)
        end

        it 'is expected to aggregate results' do
          Processor::Aggregator.aggregate(root_module_result, native_metrics)
        end
      end
    end
  end
end