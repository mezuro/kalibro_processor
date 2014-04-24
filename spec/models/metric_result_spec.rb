require 'spec_helper'

describe MetricResult do
  describe "method" do
    describe "initialize" do
      context "with valid attributes" do
        let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
        let!(:value) { 4.2 }
        subject { MetricResult.new(metric_configuration, value) }

        it 'should return an instance of MetricResult' do
          subject.should be_a(MetricResult)
        end

        it 'should have the right attributes' do
          subject.value.should eq(value)
          subject.error.should be_nil
        end

        it 'should have the average method' do
          subject.descendant_results = []
          subject.descendant_results.should respond_to :average
        end
      end
    end

    describe 'aggregated_value' do
      let(:metric_configuration){ FactoryGirl.build(:metric_configuration) }

      context 'when value is NaN and the descendant_results array is not empty' do
        subject { FactoryGirl.build(:metric_result, metric_configuration: metric_configuration) }

        before :each do
          metric_configuration.expects(:aggregation_form).returns(:AVERAGE)
        end

        it 'should calculate the average value of the descendant_results array' do
          subject.aggregated_value.should eq(2.0)
        end
      end

      context 'when the metric_results are not from a leaf module' do
        subject { FactoryGirl.build(:metric_result_with_value, metric_configuration: metric_configuration) }

        it 'should return the value' do
          subject.aggregated_value.should eq(metric_result.value)
        end
      end
    end
  end
end
