require 'spec_helper'

describe MetricResult do
  describe "method" do
    describe "initialize" do
      context "with valid attributes" do
        metric = FactoryGirl.build(:metric)
        metric_configuration = Mocha.mocha
        metric_configuration.expects(:metric).returns(metric)
        value = 4.2
        metric_result = MetricResult.new(metric_configuration, value)

        it 'should return an instance of MetricResult' do
          metric_result.should be_a(MetricResult)
        end

        it 'should have the right attributes' do 
          metric_result.value.should eq(value)
          metric_result.error.should be_nil
        end

        it 'should have the average method' do
          metric_result.descendant_results.should respond_to :average
        end
      end
    end

    describe 'aggregate_value' do
      pending 'Metric result factory is not working' do
        context 'when value is NaN and the descendant_results array is not empty' do
          metric_result = FactoryGirl.build(:metric_result)
          it 'should calculate the average value of the descendant_results array' do
            metric_result.aggregated_value.should eq(2.0)
          end
        end
      end
    end
  end
end
