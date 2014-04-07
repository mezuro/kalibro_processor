require 'spec_helper'

describe BaseTool do
  describe 'methods' do
    subject { FactoryGirl.build(:base_tool) }

    describe 'find_supported_metric_by_name' do
      context 'when the metric is supported' do
        let(:metric) { FactoryGirl.build(:native_metric) }

        it 'should return the metric' do
          subject.find_supported_metric_by_name(metric.name).name.should eq(metric.name)
        end
      end

      context 'when the metric is not supported' do
        it 'should raise a error' do
          expect { subject.find_supported_metric_by_name("Not a metric name") }.to raise_error(Errors::NotFoundError)
        end
      end
    end
  end
end