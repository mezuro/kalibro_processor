require 'rails_helper'

describe Processor::Aggregator do
  describe 'methods' do
    pending describe 'aggregate' do
      let!(:root_module_result) { FactoryGirl.build(:module_result) }
      let!(:module_result) { FactoryGirl.build(:module_result_class_granularity, parent: root_module_result) }
      let!(:compound_metric_configurations) { [FactoryGirl.build(:compound_metric_configuration)] }

      pending context 'when the module result tree has been well-built' do

        before :each do
          module_result.expects(:metric_results).twice.returns([metric_result])
          module_result.expects(:children).times(3).returns([])
          root_module_result.expects(:metric_results).twice.returns([])
          root_module_result.expects(:children).times(6).returns([module_result])
          processing.expects(:root_module_result).times(3).returns(root_module_result)
          MetricResult.any_instance.expects(:aggregated_value).twice.returns(1.0)
          MetricResult.any_instance.expects(:save).twice.returns(true)
        end

        it 'is expected to aggregate results' do
          Processor::Aggregator.aggregate(root_module_result, native_metrics)
        end
      end
    end
  end
end