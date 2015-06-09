require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser do
  describe 'methods' do
    let!(:metric_configuration) { FactoryGirl.build(:radon_configuration) }
    let(:wanted_metric_configurations) { [metric_configuration] }
    let(:radon_results) { FactoryGirl.build(:radon_collector_lists) }
    let(:processing) { FactoryGirl.build(:processing) }
    describe 'parse_all' do
      before :each do
        File.expects(:read).returns(radon_results.results)
       
      end

      it 'is expected to call all parsers' do
         MetricCollector::Native::Radon::Parser::Raw.expects(:parse)
         MetricCollector::Native::Radon::Parser::Cyclomatic.expects(:parse)
         MetricCollector::Native::Radon::Parser::Maintainability.expects(:parse)
         MetricCollector::Native::Radon::Parser.parse_all("/test/test/", wanted_metric_configurations, processing)
      end
    end

    describe 'default_value_from' do

      it "is expected to call the default_value from the metric parser's" do
        value = MetricCollector::Native::Radon::Parser::Cyclomatic.default_value
        expect(value).not_to be_nil
        MetricCollector::Native::Radon::Parser.default_value_from(metric_configuration.metric.code)
      end

    end
  end
end
