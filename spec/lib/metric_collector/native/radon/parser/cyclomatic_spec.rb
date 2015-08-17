require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser::Cyclomatic do
  describe 'parse' do
    let(:cc_results) { FactoryGirl.build(:radon_collector_lists).results[:cc] }
    let(:processing) { FactoryGirl.build(:processing) }
    let(:metric_configuration) { FactoryGirl.build(:cyclomatic_metric_configuration) }
    let(:secondary_metric_configuration) { FactoryGirl.build(:cyclomatic_metric_configuration) }
    let!(:kalibro_module_method1) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:kalibro_module_method2) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:kalibro_module_method3) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:kalibro_module_function) { FactoryGirl.build(:kalibro_module_with_method_granularity) }
    let!(:module_result) { FactoryGirl.build(:module_result) }
    context 'when there are no ModuleResults with the same module and processing' do
      it 'is expected to parse the results into a module result' do
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Client.method1", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD)
          .returns(kalibro_module_method1)
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Client.method2", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD)
          .returns(kalibro_module_method2)
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Class.setUp", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD)
          .returns(kalibro_module_method3)
        KalibroModule.expects(:new).with(long_name: "app.models.repository.callFunction", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD)
          .returns(kalibro_module_function)

        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method1, processing).returns(nil)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method2, processing).returns(module_result)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method3, processing).returns(module_result)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_function, processing).returns(module_result)
        kalibro_module_method1.expects(:save)

        ModuleResult.expects(:create).with(kalibro_module: kalibro_module_method1, processing: processing).returns(module_result)
        MetricResult.expects(:create).with(metric: metric_configuration.metric, value: 1.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        MetricResult.expects(:create).with(metric: metric_configuration.metric, value: 5.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        MetricResult.expects(:create).with(metric: metric_configuration.metric, value: 2.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        MetricResult.expects(:create).with(metric: metric_configuration.metric, value: 3.0, module_result: module_result, metric_configuration_id: metric_configuration.id)

        MetricCollector::Native::Radon::Parser::Cyclomatic.parse(cc_results, processing, metric_configuration)
      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 1.0' do
      expect(MetricCollector::Native::Radon::Parser::Cyclomatic.default_value).to eq(1.0)
    end
  end

  describe 'command' do
    it 'is expected to return cc' do
      expect(MetricCollector::Native::Radon::Parser::Cyclomatic.command).to eq('cc')
    end
  end
end

