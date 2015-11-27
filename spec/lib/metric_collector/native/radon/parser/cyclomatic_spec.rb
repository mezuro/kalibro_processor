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
    let!(:kalibro_module_function) { FactoryGirl.build(:kalibro_module_with_function_granularity) }
    let!(:module_result) { FactoryGirl.build(:module_result) }
    context 'when there are no ModuleResults with the same module and processing' do
      before do
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Client.method1", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD)
          .returns(kalibro_module_method1)
        KalibroModule.expects(:new).with(long_name: "app.models.repository.Client.method2", granularity: KalibroClient::Entities::Miscellaneous::Granularity::METHOD)
          .returns(kalibro_module_method2)
        KalibroModule.expects(:new).with(long_name: "app.models.repository.callFunction", granularity: KalibroClient::Entities::Miscellaneous::Granularity::FUNCTION)
          .returns(kalibro_module_function)

        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method1, processing).returns(nil)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_method2, processing).returns(module_result)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_function, processing).returns(module_result)
        kalibro_module_method1.expects(:save)

        module_result.expects(:update).with(kalibro_module: kalibro_module_method1)
        ModuleResult.expects(:create).with(processing: processing).returns(module_result)
        TreeMetricResult.expects(:create).with(metric: metric_configuration.metric, value: 1.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        TreeMetricResult.expects(:create).with(metric: metric_configuration.metric, value: 5.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
        TreeMetricResult.expects(:create).with(metric: metric_configuration.metric, value: 3.0, module_result: module_result, metric_configuration_id: metric_configuration.id)
      end

      it 'is expected to parse the results into a module result' do
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

