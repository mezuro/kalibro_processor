require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Parser do
  describe 'methods' do
    let(:wanted_metric_configurations) { {:flog => FactoryGirl.build(:flog_metric_configuration)} }
    let(:metric_fu_results) { FactoryGirl.build(:metric_fu_metric_collector_lists) }
    let(:processing) { FactoryGirl.build(:processing) }
    describe 'parse_all' do
      before :each do
        YAML.expects(:load_file).returns(metric_fu_results.flog_results)
      end

      it 'is expected to call all parsers' do
        MetricCollector::Native::MetricFu::Parser::Flog.expects(:parse)
        MetricCollector::Native::MetricFu::Parser.parse_all("/test/test", wanted_metric_configurations, processing)
      end
    end
  end
end