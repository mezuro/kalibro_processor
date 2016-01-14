require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Analizo::Parser, :type => :model do
  describe 'methods' do
    describe 'parse_all' do
      let!(:code) { "acc" }
      let!(:metric_collector_details) { FactoryGirl.build(:metric_collector_details) }
      let!(:native_metric) { metric_collector_details.supported_metrics["acc"] }
      let!(:wanted_metric_configuration) { FactoryGirl.build(:metric_configuration, metric: native_metric) }
      let!(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list) }
      let!(:wanted_metrics_list) { { code => wanted_metric_configuration } }
      let!(:processing) { FactoryGirl.build(:processing) }
      let!(:root_kalibro_module) {FactoryGirl.build(:kalibro_module_with_software_granularity)}
      let!(:class_kalibro_module) {FactoryGirl.build(:kalibro_module_with_class_granularity)}
      let!(:module_result) { FactoryGirl.build(:module_result) }

      subject { MetricCollector::Native::Analizo::Parser.new(processing: processing, wanted_metrics: wanted_metrics_list) }

      it 'is expected to parse the raw results into ModuleResults and TreeMetricResults' do
        YAML.expects(:load_documents).with(analizo_metric_collector_list.raw_result).returns(analizo_metric_collector_list.parsed_result)
        KalibroModule.expects(:new).with(long_name: "ROOT", granularity: KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE).returns(root_kalibro_module)
        KalibroModule.expects(:new).with(long_name: "Class.Module", granularity: KalibroClient::Entities::Miscellaneous::Granularity::CLASS).returns(class_kalibro_module)
        ModuleResult.expects(:find_by_module_and_processing).with(root_kalibro_module, processing).returns(nil)
        ModuleResult.expects(:find_by_module_and_processing).with(class_kalibro_module, processing).returns(module_result)
        root_kalibro_module.expects(:save!)
        module_result.expects(:update).with(kalibro_module: root_kalibro_module)
        ModuleResult.expects(:create).with(processing: processing).returns(module_result)
        processing.expects(:update!).with(root_module_result: module_result)
        TreeMetricResult.expects(:create).with(metric: metric_collector_details.supported_metrics["acc"], value: 0.0, module_result: module_result, metric_configuration_id: wanted_metric_configuration.id)

        subject.parse_all(analizo_metric_collector_list.raw_result)
      end
    end

    describe 'default_value_from' do
      it 'is expected to ignore the code and return 0' do
        expect(MetricCollector::Native::Analizo::Parser.default_value_from('anything')).to eq(0.0)
      end
    end
  end
end
