require 'rails_helper'

describe TreeMetricResultsController do
  it_behaves_like 'MetricResultsController'

  describe 'method' do
    describe 'descendant_values' do
      let!(:metric_result) { FactoryGirl.build(:tree_metric_result, :with_value, id: 1) }
      let!(:module_result) { FactoryGirl.build(:module_result) }

      before :each do
        MetricResult.expects(:find).with(metric_result.id).returns(metric_result)
        metric_result.expects(:descendant_values).returns([metric_result.value])
      end

      context 'json format' do
        before :each do
          post :descendant_values, id: metric_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'returns the list of values' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({descendant_values: [metric_result.value]}.to_json))
        end
      end
    end
  end
end
