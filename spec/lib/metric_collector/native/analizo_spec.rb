require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Analizo, :type => :model do
  describe 'method' do
    let(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list) }

    describe 'available?' do
      context 'when analizo is installed' do
        before :each do
          MetricCollector::Native::Analizo.expects(:`).with("analizo --version").returns(analizo_metric_collector_list.version)
        end
        it 'is expected to be truthy' do
          expect(MetricCollector::Native::Analizo.available?).to be_truthy
        end
      end
      context 'when analizo is not installed' do
        before :each do
          MetricCollector::Native::Analizo.expects(:`).with("analizo --version").returns(nil)
        end
        it 'is expected to be falsey' do
          expect(MetricCollector::Native::Analizo.available?).to be_falsey
        end
      end
    end

    describe 'description' do
      it 'is expected to return the description as a string' do
        expect(MetricCollector::Native::Analizo.description).to be_a(String)
      end
    end

    describe 'supported_metrics' do
      before :each do
        MetricCollector::Native::Analizo.expects(:`).with("analizo metrics --list").returns(analizo_metric_collector_list.raw)
      end

      it 'should return a list with all the supported metrics' do
        expect(MetricCollector::Native::Analizo.supported_metrics['total_abstract_classes'].name).to eq(analizo_metric_collector_list.parsed['total_abstract_classes'].name)
      end
    end

    describe 'collect_metrics' do
      include MockHelper
      let!(:wanted_metric_configuration) { FactoryGirl.build(:metric_configuration, metric: native_metric, code: "acc") }
      let!(:wanted_metrics) { [wanted_metric_configuration] }
      let!(:supported_metrics) { {"acc" => native_metric} }
      let!(:absolute_path) { "app/models/metric.rb" }
      let!(:module_result) { FactoryGirl.build(:module_result) }

      let(:native_metric) { FactoryGirl.build(:analizo_native_metric) }
      let(:wanted_metrics_list) { [wanted_metric_configuration, FactoryGirl.build(:metric_configuration, code: "amloc")] }
      let(:processing) { FactoryGirl.build(:processing) }

      before :each do
        subject.expects(:`).with("analizo metrics #{absolute_path}").returns(analizo_metric_collector_list.raw_result)
        MetricCollector::Native::Analizo.expects(:supported_metrics).twice.returns(supported_metrics)
        MetricResult.expects(:create).with(metric: native_metric,
                                           value: analizo_metric_collector_list.parsed_result[1]["acc"].to_f,
                                           module_result: module_result,
                                           metric_configuration_id: wanted_metric_configuration.id).returns(FactoryGirl.build(:metric_result))
      end

      context 'when there are no ModuleResults with the same module and processing' do
        before :each do
          KalibroModule.any_instance.expects(:save).twice.returns(true)
          ModuleResult.expects(:create).at_least_once.returns(module_result)
          find_module_result_mocks
        end

        it 'should collect the metrics for a given project' do
          expect(subject.collect_metrics(absolute_path, wanted_metrics_list, processing)).to eq(analizo_metric_collector_list.parsed_result)
        end
      end

      context 'when there is an existing ModuleResult with the same module and processing' do
        before :each do
          find_module_result_mocks([module_result])
        end

        it 'should collect the metrics for a given project' do
          expect(subject.collect_metrics(absolute_path, wanted_metrics_list, processing)).to eq(analizo_metric_collector_list.parsed_result)
        end
      end
    end
  end
end
