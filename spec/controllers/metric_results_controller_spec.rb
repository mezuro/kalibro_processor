require 'spec_helper'

describe MetricResultsController do
  describe 'method' do
    describe 'descendant_values' do
      let!(:metric_result) { FactoryGirl.build(:metric_result, id: 1) }
      let!(:module_result) { FactoryGirl.build(:module_result) }

      before :each do
        module_result.expects(:metric_result_for).with(metric_result.metric).returns(metric_result)
        module_result.expects(:children).returns([module_result])
        metric_result.expects(:module_result).returns(module_result)
        MetricResult.expects(:find).with(metric_result.id.to_s).returns(metric_result)
      end

      context 'json format' do
        before :each do
          post :descendant_values, id: metric_result.id, format: :json
        end

        it { should respond_with(:success) }

        it 'returns the list of values' do
          JSON.parse(response.body).should eq(JSON.parse({descendant_values: [metric_result.value]}.to_json))
        end
      end
    end
  end
end
