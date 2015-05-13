require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Parser do
  describe 'methods' do
    let!(:metric_configuration) { FactoryGirl.build(:flog_metric_configuration) }
    let(:wanted_metric_configurations) { [metric_configuration] }
    let(:metric_fu_results) { FactoryGirl.build(:metric_fu_metric_collector_lists) }
    let(:processing) { FactoryGirl.build(:processing) }
    describe 'parse_all' do
      before :each do
        YAML.expects(:load_file).returns(metric_fu_results.results)
      end

      it 'is expected to call all parsers' do
        MetricCollector::Native::MetricFu::Parser::Flog.expects(:parse)
        MetricCollector::Native::MetricFu::Parser.parse_all("/test/test", wanted_metric_configurations, processing)
      end
    end

    describe 'default_value_from' do

      it "is expected to call the default_value from the metric parser's" do
        MetricCollector::Native::MetricFu::Parser::Flog.expects(:default_value)

        MetricCollector::Native::MetricFu::Parser.default_value_from(metric_configuration.metric.code)
      end
    end
  end
end
