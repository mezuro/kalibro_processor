require 'rails_helper'
require 'metric_collector'
require 'processor'

describe Processor::MetricResultsChecker do
  describe 'methods' do
    describe 'task' do
      let(:kalibro_configuration) { FactoryGirl.build(:kalibro_configuration) }
      let(:code_dir) { "/tmp/test" }
      let(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", kalibro_configuration: kalibro_configuration, code_directory: code_dir) }
      let(:flog_metric_configuration) { FactoryGirl.build(:flog_metric_configuration) }
      let(:saikuro_metric_configuration) { FactoryGirl.build(:saikuro_metric_configuration, id: 1) }
      let(:metric_result) { FactoryGirl.build(:metric_result,
                                               metric_configuration: saikuro_metric_configuration) }
      let(:module_result) { FactoryGirl.build(:module_result_class_granularity) }
      let(:processing) { FactoryGirl.build(:processing, repository: repository, root_module_result: module_result, module_results: [module_result]) }
      let(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }

      context 'when there is a wanted metric that produced no results for the given module' do
        let!(:default_value) { 0.0 }
        before :each do
          context.native_metrics['MetricFu'] << flog_metric_configuration
          context.native_metrics['MetricFu'] << saikuro_metric_configuration
          metric_result.expects(:metric).returns(FactoryGirl.build(:saikuro_metric))
          module_result.stubs(:metric_results).returns([metric_result])
          MetricCollector::Native::MetricFu::Parser.expects(:default_value_from).with(flog_metric_configuration.metric.code).returns(default_value)
        end

        it 'is expected to create a TreeMetricResult with the default value for this metric' do
          TreeMetricResult.expects(:create).with(value: default_value, module_result: module_result, metric_configuration_id: flog_metric_configuration.id)

          Processor::MetricResultsChecker.task(context)
        end
      end

    end

    describe 'state' do
      it 'is expected to return CHECKING' do
        expect(Processor::MetricResultsChecker.state).to eq('CHECKING')
      end
    end
  end
end