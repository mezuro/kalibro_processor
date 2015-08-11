require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser::Maintainability do
  describe 'parse' do
    let(:mi_results) { FactoryGirl.build(:radon_collector_lists).results[:mi] }
    let(:processing) { FactoryGirl.build(:processing) }
    let(:mi_configuration) { FactoryGirl.build(:maintainability_metric_configuration) }
    let!(:kalibro_module_package) { FactoryGirl.build(:kalibro_module_with_package_granularity) }
    let!(:module_result) { FactoryGirl.build(:module_result) }

    context 'when there are no ModuleResults with the same module and processing' do
      it 'is expected to parse the results into a module result' do
        KalibroModule.expects(:new).with(long_name: "app.models.repository", granularity: Granularity::PACKAGE)
            .returns(kalibro_module_package)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module_package, processing).returns(nil)
        kalibro_module_package.expects(:save)

        ModuleResult.expects(:create).with(kalibro_module: kalibro_module_package, processing: processing).returns(module_result)

        MetricResult.expects(:create).with(metric: mi_configuration.metric, value: 100.0, module_result: module_result, metric_configuration_id: mi_configuration.id)

        MetricCollector::Native::Radon::Parser::Maintainability.parse(mi_results, processing, mi_configuration)
      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 100.0' do
      expect(MetricCollector::Native::Radon::Parser::Maintainability.default_value).to eq(100.0)
    end
  end

  describe 'command' do
    it 'is expected to return mi' do
      expect(MetricCollector::Native::Radon::Parser::Maintainability.command).to eq('mi')
    end
  end
end
