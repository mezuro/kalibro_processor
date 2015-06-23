require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Collector, :type => :model do

  describe 'collect_metrics' do
    let(:code_directory) { Dir.pwd }
    let(:wanted_metrics) { {} }
    let(:runner) { mock('radon_runner') }
    let(:processing) { FactoryGirl.build(:processing) }

    subject{ MetricCollector::Native::Radon::Collector.new }

    it 'is expected to run the collector and parse the results' do
      MetricCollector::Native::Radon::Runner.expects(:new).with(repository_path: code_directory, wanted_metric_configurations: wanted_metrics).returns(runner)
      runner.expects(:run_wanted_metrics)
      MetricCollector::Native::Radon::Parser.expects(:parse_all).with(code_directory, wanted_metrics, processing)
      runner.expects(:clean_output)
      subject.collect_metrics(code_directory, wanted_metrics, processing)
    end
  end
end