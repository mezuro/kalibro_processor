require 'rails_helper'
require 'processor'

describe Processor::Aggregator do
  describe 'methods' do
    describe 'task' do
      let(:kalibro_configuration) { FactoryGirl.build(:kalibro_configuration) }
      let!(:code_dir) { "/tmp/test" }
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", kalibro_configuration: kalibro_configuration, code_directory: code_dir) }
      let!(:root_module_result) { FactoryGirl.build(:module_result) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository, root_module_result: root_module_result) }
      let!(:compound_metric_configurations) { [FactoryGirl.build(:compound_metric_configuration)] }
      let!(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }

      context 'when the module result tree has been well-built' do
        context 'with a linear hierarchy' do
          let!(:child) { FactoryGirl.build(:module_result_class_granularity, parent: root_module_result) }
          let!(:native_metric_configurations) {
            [FactoryGirl.build(:metric_configuration, id: 1),
             FactoryGirl.build(:metric_configuration, metric: FactoryGirl.build(:loc_metric), id: 2)]
          }
          let!(:native_metrics) { { "Analizo" => native_metric_configurations } }
          let!(:all_metrics) { [native_metric_configurations.first.metric, native_metric_configurations.last.metric] }
          let!(:metric_results) { [FactoryGirl.build(:metric_result, :with_value, metric_configuration: native_metric_configurations.first, metric: native_metric_configurations.first.metric),
                                   FactoryGirl.build(:metric_result, :with_value, metric_configuration: native_metric_configurations.last, metric: native_metric_configurations.last.metric)] }

          before :each do
            context.native_metrics = native_metrics
            child.expects(:metric_results).returns(metric_results)
            root_module_result.expects(:pre_order).returns([root_module_result, child])
            TreeMetricResult.any_instance.expects(:save)
          end

          it 'is expected to aggregate results' do
            Processor::Aggregator.task(context)
          end
        end

        context 'with a multi-level package hierarchy' do
          let!(:parent) { FactoryGirl.build(:module_result, :package, parent: root_module_result) }
          let!(:child) { FactoryGirl.build(:module_result, :package, parent: parent) }
          let!(:another_child) { FactoryGirl.build(:module_result, :package, parent: parent) }
          let!(:native_metric_configurations) {
            [FactoryGirl.build(:metric_configuration, metric: FactoryGirl.build(:maintainability_metric), id: 1)]
          }
          let!(:native_metrics) { { "Radon" => native_metric_configurations } }
          let!(:all_metrics) { [native_metric_configurations.first.metric] }
          let!(:metric_results) { [FactoryGirl.build(:metric_result, :with_value, metric_configuration: native_metric_configurations.first, metric: native_metric_configurations.first.metric)] }

          before :each do
            context.native_metrics = native_metrics
            child.expects(:metric_results).returns(metric_results)
            another_child.expects(:metric_results).returns(metric_results)
            root_module_result.expects(:pre_order).returns([root_module_result, parent, child, another_child])
            TreeMetricResult.any_instance.expects(:save).twice
            MetricResultAggregator.expects(:aggregated_value).twice
          end

          it 'is expected to aggregate results' do
            Processor::Aggregator.task(context)
          end
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
