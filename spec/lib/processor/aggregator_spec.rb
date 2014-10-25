require 'rails_helper'
require 'processor'

describe Processor::Aggregator do
  describe 'methods' do
    describe 'task' do
      let(:configuration) { FactoryGirl.build(:configuration) }
      let!(:code_dir) { "/tmp/test" }
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", configuration: configuration, code_directory: code_dir) }
      let!(:root_module_result) { FactoryGirl.build(:module_result) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository, root_module_result: root_module_result) }
      let!(:child) { FactoryGirl.build(:module_result_class_granularity, parent: root_module_result) }
      let!(:native_metric_configurations) {
        [FactoryGirl.build(:metric_configuration, id: 1),
          FactoryGirl.build(:metric_configuration, metric: FactoryGirl.build(:kalibro_gatekeeper_client_loc), id: 2)]
      }
      let!(:compound_metric_configurations) { [FactoryGirl.build(:compound_metric_configuration)] }
      let!(:native_metrics) { { "Analizo" => native_metric_configurations } }
      let!(:all_metrics) { [native_metric_configurations.first.metric, native_metric_configurations.last.metric] }
      let!(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }

      before :each do
        context.native_metrics = native_metrics
      end

      context 'when the module result tree has been well-built' do

        before :each do
          root_module_result.expects(:pre_order).returns([root_module_result, child])
          MetricResult.any_instance.expects(:save)
        end

        it 'is expected to aggregate results' do
          Processor::Aggregator.task(context)
        end
      end
    end

    describe 'state' do
      it 'is expected to return "AGGREGATING"' do
        expect(Processor::Aggregator.state).to eq("AGGREGATING")
      end
    end
  end
end
