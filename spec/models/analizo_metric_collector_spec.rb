require 'rails_helper'

describe AnalizoMetricCollector, :type => :model do
  describe 'method' do
    let(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list) }

    describe 'description' do
      it 'is expected to return the description as a string' do
        expect(AnalizoMetricCollector.description).to be_a(String)
      end
    end

    describe 'supported_metrics' do
      before :each do
        AnalizoMetricCollector.expects(:`).with("analizo metrics --list").returns(analizo_metric_collector_list.raw)
      end

      it 'should return a list with all the supported metrics' do
        expect(AnalizoMetricCollector.supported_metrics['total_abstract_classes'].name).to eq(analizo_metric_collector_list.parsed['total_abstract_classes'].name)
      end
    end

    describe 'collect_metrics' do
      include RunnerMockHelper
      let!(:wanted_metrics) { {"acc" => native_metric} }
      let!(:absolute_path) { "app/models/metric.rb" }
      let!(:module_result) { FactoryGirl.build(:module_result) }

      let(:native_metric) { FactoryGirl.build(:analizo_native_metric) }
      let(:wanted_metrics_list) { ["acc", "amloc"] }
      let(:processing) { FactoryGirl.build(:processing) }

      before :each do
        subject.expects(:`).with("analizo metrics #{absolute_path}").returns(analizo_metric_collector_list.raw_result)
        AnalizoMetricCollector.expects(:supported_metrics).returns(wanted_metrics)
        KalibroModule.expects(:create).at_least_once.returns(FactoryGirl.build(:kalibro_module))
        ModuleResult.expects(:create).at_least_once.returns(module_result)
        MetricResult.expects(:create).with(metric: native_metric,
                                           value: analizo_metric_collector_list.parsed_result[1]["acc"],
                                           module_result: module_result).returns(FactoryGirl.build(:metric_result))
        find_module_result_mocks
      end

      it 'should collect the metrics for a given project' do
        expect(subject.collect_metrics(absolute_path, wanted_metrics_list, processing)).to eq(analizo_metric_collector_list.parsed_result)
      end
    end
  end
end