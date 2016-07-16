require 'rails_helper'
require 'metric_collector'

describe MetricCollector::PersistenceStrategy do
  let(:kalibro_module) { FactoryGirl.build(:kalibro_module) }
  let(:processing) { FactoryGirl.build(:processing) }
  let(:module_result) { FactoryGirl.build(:module_result, processing: processing) }
  let(:metric_configuration) { FactoryGirl.build(:metric_configuration, :with_id) }

  subject { described_class.new(processing) }

  describe 'new_kalibro_module' do
    it 'is expected to return a new object with the correct attributes' do
      result = subject.send(:new_kalibro_module, kalibro_module.long_name, kalibro_module.granularity)
      expect(result.attributes).to eq(kalibro_module.attributes)
    end
  end

  describe 'create_tree_metric_result' do
    let(:value) { 10 }
    let(:tree_metric_result) { mock('tree_metric_result') }

    context 'when the module result was found' do
      before do
        subject.expects(:new_kalibro_module).returns(kalibro_module)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module, processing).returns module_result
        TreeMetricResult.expects(:create!).with(module_result: module_result,
                                                metric_configuration_id: metric_configuration.id,
                                                value: value).returns tree_metric_result
      end

      it 'is expected to create a tree metric result' do
        subject.create_tree_metric_result(metric_configuration, kalibro_module.long_name, value, kalibro_module.granularity)
      end
    end

    context "when the module result wasn't found" do
      before do
        subject.expects(:new_kalibro_module).returns(kalibro_module)
        ModuleResult.expects(:find_by_module_and_processing).with(kalibro_module, processing).returns nil
        kalibro_module.expects(:build_module_result).with(processing: processing) do
          kalibro_module.module_result = module_result
        end
        kalibro_module.expects(:save!)
        TreeMetricResult.expects(:create!).with(module_result: module_result,
                                                metric_configuration_id: metric_configuration.id,
                                                value: value).returns tree_metric_result
      end

      it 'is expected to create a tree metric result' do
        subject.create_tree_metric_result(metric_configuration, kalibro_module.long_name, value, kalibro_module.granularity)
      end
    end
  end

  describe 'create_hotspot_metric_result' do
    let(:hotspot_metric_result) { FactoryGirl.build(:hotspot_metric_result) }

    before do
      subject.expects(:find_or_create_module_result).with(
        kalibro_module.long_name,
        KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE).returns(module_result)
    end

    it 'is expected to create a hotspot metric result' do
      HotspotMetricResult.expects(:create!).with(module_result: module_result,
                                                 metric_configuration_id: metric_configuration.id,
                                                 line_number: hotspot_metric_result.line_number,
                                                 message: hotspot_metric_result.message).returns hotspot_metric_result
      subject.create_hotspot_metric_result(
        metric_configuration,
        kalibro_module.long_name,
        hotspot_metric_result.line_number,
        hotspot_metric_result.message)
    end
  end

  describe 'create_related_hotspot_metric_results' do
    let(:hotspot_metric_result) { FactoryGirl.build(:hotspot_metric_result) }
    let(:hotspot_metric_result_attributes) {
      attributes = hotspot_metric_result.attributes.slice('line_number', 'message')
      attributes['line'] = attributes.delete('line_number')
      attributes['module_name'] = kalibro_module.long_name
      attributes
    }
    let(:results_list) { Array.new(3, hotspot_metric_result) }
    let(:attributes_list) { Array.new(3, hotspot_metric_result_attributes) }

    before :each do
      subject.expects(:create_hotspot_metric_result).with(metric_configuration,
                                                          kalibro_module.long_name,
                                                          hotspot_metric_result.line_number,
                                                          hotspot_metric_result.message).times(3).returns(hotspot_metric_result)
      RelatedHotspotMetricResults.expects(:create!).with(hotspot_metric_results: results_list)
    end

    it 'should create the hotspot metric results and ensure they are related' do
      subject.create_related_hotspot_metric_results(metric_configuration, attributes_list)
    end
  end
end
