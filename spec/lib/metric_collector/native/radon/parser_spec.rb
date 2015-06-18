require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser do
  describe 'methods' do
    let!(:metric_configuration) { FactoryGirl.build(:cyclomatic_configuration) }
    let(:wanted_metric_configurations) { [metric_configuration] }
    let(:radon_results) { FactoryGirl.build(:radon_collector_lists) }
    let(:processing) { FactoryGirl.build(:processing) }
    let!(:repository_path) { Dir.pwd }
    subject { MetricCollector::Native::Radon::Runner.new(repository_path: repository_path,wanted_metric_configurations: wanted_metric_configurations) }
    describe 'parse_all' do
      it 'is expected to call all parsers' do
        subject.run_wanted_metrics
        MetricCollector::Native::Radon::Parser.parse_all(repository_path, wanted_metric_configurations, processing)
        subject.clean_output
      end

    end

    describe 'default_value_from' do

      it "is expected to call the default_value from the metric parser's" do
        #value = MetricCollector::Native::Radon::Parser::Cyclomatic.default_value
        #expect(value).not_to be_nil
        MetricCollector::Native::Radon::Parser.default_value_from(metric_configuration.metric.code)
      end

    end
  end
end
