require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Parser::Saikuro do
  describe 'parse' do
    let!(:saikuro_results) { FactoryGirl.build(:metric_fu_metric_collector_lists).results[:saikuro] }
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:kalibro_module_method_process) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:kalibro_module_method_reprocess) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:module_result) { FactoryGirl.build(:module_result) }
    let!(:metric_configuration) { FactoryGirl.build(:saikuro_metric_configuration) }

    context 'when there are no ModuleResults with the same module and processing' do
      it 'is expected to parse the results into a module result' do
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Repository.process", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD).returns(kalibro_module_method_process)
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Repository.reprocess", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD).returns(kalibro_module_method_reprocess)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method_process, processing).returns(nil)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method_reprocess, processing).returns(module_result)
        kalibro_module_method_process.expects(:save)
        module_result.expects(:update).with(kalibro_module: kalibro_module_method_process)
        ModuleResult.expects(:create).with(processing: processing).returns(module_result)
        TreeMetricResult.expects(:create).with(metric: metric_configuration.metric, value: 5.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        TreeMetricResult.expects(:create).with(metric: metric_configuration.metric, value: 10.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        MetricCollector::Native::MetricFu::Parser::Saikuro.parse(saikuro_results, processing, metric_configuration)
      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 1.0' do
      expect(MetricCollector::Native::MetricFu::Parser::Saikuro.default_value).to eq(1.0)
    end
  end
end

