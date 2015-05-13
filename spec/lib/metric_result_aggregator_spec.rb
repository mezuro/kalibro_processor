require 'rails_helper'
require 'metric_result_aggregator'

describe MetricResultAggregator, :type => :model do
  describe 'method' do
    let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
    let!(:another_metric_configuration) { FactoryGirl.build(:another_metric_configuration) }
    let!(:sum_metric_configuration) { FactoryGirl.build(:sum_metric_configuration) }
    let!(:maximum_metric_configuration) { FactoryGirl.build(:maximum_metric_configuration) }
    let!(:minimum_metric_configuration) { FactoryGirl.build(:minimum_metric_configuration) }

    describe 'aggregated_value' do
      let!(:stats) { DescriptiveStatistics::Stats.new([2, 4, 6]) }

      before :each do
        subject.expects(:descendant_values).returns(stats)
      end

      context 'when value is nil and the values array is not empty' do
        subject { FactoryGirl.build(:metric_result, module_result: FactoryGirl.build(:module_result)) }

        it 'should calculate the mean value of the values array' do
          KalibroClient::Entities::Configurations::MetricConfiguration.expects(:find).
            with(subject.metric_configuration_id).returns(metric_configuration)
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(4.0)
        end

        it 'should count the values of array' do
          KalibroClient::Entities::Configurations::MetricConfiguration.expects(:find).
            with(subject.metric_configuration_id).returns(another_metric_configuration)
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(3)
        end

        it 'should sum the values of array' do
          KalibroClient::Entities::Configurations::MetricConfiguration.expects(:find).
            with(subject.metric_configuration_id).returns(sum_metric_configuration)
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(12)
        end

        it 'should minimize the values of array' do
          KalibroClient::Entities::Configurations::MetricConfiguration.expects(:find).
            with(subject.metric_configuration_id).returns(minimum_metric_configuration)
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(2)
        end

        it 'should maximize the values of array' do
          KalibroClient::Entities::Configurations::MetricConfiguration.expects(:find).
            with(subject.metric_configuration_id).returns(maximum_metric_configuration)
          expect(MetricResultAggregator.aggregated_value(subject)).to eq(6)
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
