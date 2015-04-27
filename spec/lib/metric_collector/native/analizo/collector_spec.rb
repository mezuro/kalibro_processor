require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Analizo::Collector, :type => :model do
  describe 'method' do
    let(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list) }

    describe 'available?' do
      context 'when analizo is installed' do
        before :each do
          MetricCollector::Native::Analizo::Collector.expects(:`).with("analizo --version").returns(analizo_metric_collector_list.version)
        end

        it 'is expected to be truthy' do
          expect(MetricCollector::Native::Analizo::Collector.available?).to be_truthy
        end
      end

      context 'when analizo is not installed' do
        before :each do
          MetricCollector::Native::Analizo::Collector.expects(:`).with("analizo --version").returns(nil)
        end

        it 'is expected to be falsey' do
          expect(MetricCollector::Native::Analizo::Collector.available?).to be_falsey
        end
      end
    end

    describe 'collect_metrics' do
      let(:absolute_path) { "app/models/metric.rb" }
      let(:module_result) { FactoryGirl.build(:module_result) }
      let(:wanted_metrics_list) { [FactoryGirl.build(:metric_configuration)] }
      let(:processing) { FactoryGirl.build(:processing) }

      it 'is expected to call the Runner and Parser' do
        MetricCollector::Native::Analizo::Runner.any_instance.expects(:run).returns(analizo_metric_collector_list.parsed_result)
        MetricCollector::Native::Analizo::Parser.any_instance.expects(:parse_all).with(analizo_metric_collector_list.parsed_result)

        subject.collect_metrics(absolute_path, wanted_metrics_list, processing)
      end
    end
  end
end
