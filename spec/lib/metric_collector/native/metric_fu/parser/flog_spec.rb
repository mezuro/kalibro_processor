require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Parser::Flog do
  describe 'parse' do
    let!(:flog_results) { FactoryGirl.build(:metric_fu_metric_collector_lists).results[:flog] }
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:kalibro_module_method_process) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:kalibro_module_method_reprocess) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:module_result) { FactoryGirl.build(:module_result) }
    let!(:metric_configuration) { FactoryGirl.build(:flog_metric_configuration) }

    context 'when there are no ModuleResults with the same module and processing' do
      it 'is expected to parse the results into a module result' do
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Repository.process", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD).returns(kalibro_module_method_process)
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Repository.reprocess", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD).returns(kalibro_module_method_reprocess)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method_process, processing).returns(nil)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method_reprocess, processing).returns(module_result)
        kalibro_module_method_process.expects(:save)
        ModuleResult.expects(:create).with(kalibro_module: kalibro_module_method_process, processing: processing).returns(module_result)
        TreeMetricResult.expects(:create).with(metric: metric_configuration.metric, value: 1.1, module_result: module_result, metric_configuration_id: metric_configuration.id)
        TreeMetricResult.expects(:create).with(metric: metric_configuration.metric, value: 2.0, module_result: module_result, metric_configuration_id: metric_configuration.id)

        MetricCollector::Native::MetricFu::Parser::Flog.parse(flog_results, processing, metric_configuration)
      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 0.0' do
      expect(MetricCollector::Native::MetricFu::Parser::Flog.default_value).to eq(0.0)
    end
  end
end
