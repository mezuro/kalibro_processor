require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser::Raw do
  describe 'parse' do
    let(:raw_results) { FactoryGirl.build(:radon_collector_lists).results[:raw] }
    let(:processing) { FactoryGirl.build(:processing) }
    let(:loc_configuration) { FactoryGirl.build(:lines_of_code_configuration) }
    let(:lloc_configuration) { FactoryGirl.build(:logical_lines_of_code_configuration) }
    let!(:kalibro_module_package) { FactoryGirl.build(:kalibro_module_with_package_granularity) }
    let!(:module_result) { FactoryGirl.build(:module_result) }
    context 'when there are no ModuleResults with the same module and processing' do
      it 'is expected to parse the results into a module result' do
        KalibroModule.expects(:new).twice.with(long_name: "app.models.repository", granularity: KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE)
            .returns(kalibro_module_package)
        ModuleResult.expects(:find_by_module_and_processing).times(2).with(kalibro_module_package, processing)
            .returns(nil)
            .then.returns(module_result)
        kalibro_module_package.expects(:save)

        module_result.expects(:update).with(kalibro_module: kalibro_module_package)
        ModuleResult.expects(:create).with(processing: processing).returns(module_result)

        TreeMetricResult.expects(:create).with(metric: loc_configuration.metric, value: 14, module_result: module_result, metric_configuration_id: loc_configuration.id)
        TreeMetricResult.expects(:create).with(metric: lloc_configuration.metric, value: 10, module_result: module_result, metric_configuration_id: lloc_configuration.id)

        MetricCollector::Native::Radon::Parser::Raw.parse(raw_results, processing, loc_configuration)
        MetricCollector::Native::Radon::Parser::Raw.parse(raw_results, processing, lloc_configuration)
      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 0.0' do
      expect(MetricCollector::Native::Radon::Parser::Raw.default_value).to eq(0.0)
    end
  end

  describe 'command' do
    it 'is expected to return raw' do
      expect(MetricCollector::Native::Radon::Parser::Raw.command).to eq('raw')
    end
  end
end

