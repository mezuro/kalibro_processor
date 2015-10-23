require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Collector, :type => :model do
  subject{ MetricCollector::Native::MetricFu::Collector.new }

  describe 'collect_metrics' do
    let(:code_directory) { Dir.pwd }
    let(:wanted_metrics) { {} }
    let(:path) { "" }
    let(:runner) { mock('metric_fu_runner') }
    let(:processing) { FactoryGirl.build(:processing) }

    it 'is expected to run the collector and parse the results' do
      MetricCollector::Native::MetricFu::Runner.expects(:new).with(repository_path: code_directory).returns(runner)
      runner.expects(:run)
      runner.expects(:yaml_path).returns(path)
      MetricCollector::Native::MetricFu::Parser.expects(:parse_all).with(path, wanted_metrics, processing)
      runner.expects(:clean_output)
      subject.collect_metrics(code_directory, wanted_metrics, processing)
    end
  end

  describe 'available?' do
    context 'when MetricFu is installed' do
      before :each do
        MetricCollector::Native::MetricFu::Collector.expects(:`).with("metric_fu --version").returns("")
      end

      it 'is expected to be truthy' do
        expect(MetricCollector::Native::MetricFu::Collector.available?).to be_truthy
      end
    end

    context 'when analizo is not installed' do
      before :each do
        MetricCollector::Native::MetricFu::Collector.expects(:`).with("metric_fu --version").raises(SystemCallError, "command not found: metric_fu")
      end

      it 'is expected to be falsey' do
        expect(MetricCollector::Native::MetricFu::Collector.available?).to be_falsey
      end
    end
  end
end
