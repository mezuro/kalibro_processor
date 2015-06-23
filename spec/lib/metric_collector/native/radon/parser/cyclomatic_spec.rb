require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser::Cyclomatic do
  describe 'parse' do
    let!(:radon_results) { FactoryGirl.build(:radon_collector_lists).results[:cc] }
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:metric_configuration) { FactoryGirl.build(:cyclomatic_metric_configuration) }
    let!(:secondary_metric_configuration) { FactoryGirl.build(:cyclomatic_metric_configuration) }

    context 'when there is a valid json input for cyclomatic parse' do
      before :each do
        @result = MetricCollector::Native::Radon::Parser::Cyclomatic.parse(radon_results, processing, metric_configuration)
      end

      it 'is expected to parse the results into a module result' do
        expect(@result['complexity']).to eq(radon_results['complexity'])
        expect(@result['name']).to eq(radon_results['name'])
      end
    end

    context 'when there are ModuleResults with the same module and processing' do
      before :each do
        @result = MetricCollector::Native::Radon::Parser::Cyclomatic.parse(radon_results, processing, metric_configuration)
      end

      it 'is expected to parse the results into a module result' do
        expect(MetricCollector::Native::Radon::Parser::Cyclomatic.parse(radon_results, processing, metric_configuration)).to eql(@result)
        expect(MetricCollector::Native::Radon::Parser::Cyclomatic.parse(radon_results, processing, secondary_metric_configuration)).to eql(@result)
      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 1.0' do
      expect(MetricCollector::Native::Radon::Parser::Cyclomatic.default_value).to eq(1.0)
    end
  end

  describe 'command' do
    it 'is expected to return cc' do
      expect(MetricCollector::Native::Radon::Parser::Cyclomatic.command).to eq('cc')
    end
  end
end
