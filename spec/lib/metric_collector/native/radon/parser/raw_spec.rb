require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser::Raw do
  describe 'parse' do
    let!(:radon_results) { FactoryGirl.build(:radon_collector_lists).results[:mi] }
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:metric_configuration) { FactoryGirl.build(:lines_of_code_configuration) }

    context 'when there is a valid json input for raw parse' do
      before :each do
        @result = MetricCollector::Native::Radon::Parser::Raw.parse(radon_results, processing, metric_configuration)
      end

      it 'is expected to parse the results into a module result' do
      
        expect(@result['loc']).to eq(radon_results['loc'])

      end
    end
  end

  describe 'default_value' do
    it 'is expected to return 0.0' do
      expect(MetricCollector::Native::Radon::Parser::Raw.default_value).to eq(0.0)
    end
  end

  describe 'command' do
    it 'is expected to return raw' do
      expect(MetricCollector::Native::Radon::Parser::Raw.command).to eq('raw')
    end
  end
end

