require 'rails_helper'
require "metric_result_aggregator"

describe MetricResultAggregator, :type => :model do
  describe 'method' do
    let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
    let!(:another_metric_configuration) { FactoryGirl.build(:another_metric_configuration) }

    describe 'aggregated_value' do
      let!(:stats) { DescriptiveStatistics::Stats.new([2, 4, 6]) }

      before :each do
        subject.expects(:descendant_values).returns(stats)
      end

      context 'when value is nil and the values array is not empty' do
        subject { FactoryGirl.build(:metric_result, module_result: FactoryGirl.build(:module_result)) }
        before :each do
          
        end

        it 'should calculate the mean value of the values array' do
          KalibroGatekeeperClient::Entities::MetricConfiguration.expects(:find).
            with(subject.metric_configuration_id).returns(metric_configuration)
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(4.0)
        end

        it 'should count the values of array' do
          KalibroGatekeeperClient::Entities::MetricConfiguration.expects(:find).
            with(subject.metric_configuration_id).returns(another_metric_configuration)
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(3)
        end

        after :each do
          Rails.cache.clear # This test depends on metric configuration
        end
      end

      context 'when the metric_results are not from a leaf module' do
        subject { FactoryGirl.build(:metric_result_with_value) }

        it 'should return the value' do
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(subject.value)
        end
      end
    end
  end
end
