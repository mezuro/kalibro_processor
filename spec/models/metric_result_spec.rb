require 'spec_helper'

describe MetricResult do
  describe "method" do
    describe "initialize" do
      context "with valid attributes" do
        let(:metric) { FactoryGirl.build(:metric) }
        let(:metric_configuration) { Mocha.mocha }
        let(:value) { 4.2 }
        let(:metric_result) { MetricResult.new(metric_configuration, value) }

        before :each do
          metric_configuration.expects(:metric).returns(metric)
        end

        it 'should return an instance of MetricResult' do
          metric_result.should be_a(MetricResult)
        end

        it 'should have the right attributes' do
          metric_result.value.should eq(value)
          metric_result.error.should be_nil
        end

        it 'should have the average method' do
          metric_result.descendant_results = []
          metric_result.descendant_results.should respond_to :average
        end
      end
    end

    describe 'aggregate_value' do
      let!(:metric_configuration){ Mocha.mocha }
      context 'when value is NaN and the descendant_results array is not empty' do
        let(:metric) { FactoryGirl.build(:metric) }
        let(:metric_result) { FactoryGirl.build(:metric_result, metric_configuration: metric_configuration) }

        before :each do
          metric_configuration.expects(:metric).returns(metric)
          metric_configuration.expects(:aggregation_form).returns(:AVERAGE)
        end

        it 'should calculate the average value of the descendant_results array' do
          metric_result.aggregated_value.should eq(2.0)
        end
      end

      context 'when the metric_results are not from a leaf module' do
        let(:metric) { FactoryGirl.build(:metric) }
        let(:metric_result) { FactoryGirl.build(:metric_result_with_value, metric_configuration: metric_configuration) }

        before :each do
          metric_configuration.expects(:metric).returns(metric)
          metric_configuration.expects(:aggregation_form).returns(:AVERAGE)
        end

        it 'should return the value' do
          metric_result.aggregated_value.should eq(metric_result.value)
        end
      end
    end
  end
end
