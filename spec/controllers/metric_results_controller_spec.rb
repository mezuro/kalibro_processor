require 'spec_helper'

describe MetricResultsController do
  describe 'method' do
    describe 'descendant_values' do
      let!(:metric_result) { FactoryGirl.build(:metric_result) }

      before :each do
        metric_result
        MetricResult.expects(:find).with().returns(metric_result)
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
