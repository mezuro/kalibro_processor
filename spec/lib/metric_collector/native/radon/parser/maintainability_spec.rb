require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser::Maintainability do
  describe 'parse' do
    let!(:radon_results) { FactoryGirl.build(:radon_collector_lists).results[:mi] }
    let!(:processing) { FactoryGirl.build(:processing) }
    let!(:metric_configuration) { FactoryGirl.build(:maintainability_configuration) }

    context 'when there is a valid json input for maintainability parse' do
      before :each do
        @result = MetricCollector::Native::Radon::Parser::Maintainability.parse(radon_results, processing, metric_configuration)
      end

      it 'is expected to parse the results into a module result' do
      
        expect(@result['mi']).to eq(radon_results['mi'])
        expect(@result['rank']).to eq(radon_results['rank'])

        end
    end
  end

  describe 'default_value' do
    it 'is expected to return 0.0' do
      expect(MetricCollector::Native::Radon::Parser::Maintainability.default_value).to eq(0.0)
    end
  end

  describe 'command' do
    it 'is expected to return mi' do
      expect(MetricCollector::Native::Radon::Parser::Maintainability.command).to eq('mi')
    end
  end
end
