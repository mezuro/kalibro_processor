require 'rails_helper'

describe HotspotMetricResultsController do
  it_behaves_like 'MetricResultsController'

  describe 'method' do
    describe 'related_results' do
      let!(:related_results) { FactoryGirl.build_list(:hotspot_metric_result, 2) }
      let!(:hotspot_metric_result) { FactoryGirl.build(:hotspot_metric_result, :with_id) }

      before :each do
        HotspotMetricResult.expects(:find).with(hotspot_metric_result.id).returns(hotspot_metric_result)
        hotspot_metric_result.expects(:related_results).returns(related_results)

        get :related_results, id: hotspot_metric_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'is expected to return a JSON with the related hotspot metric results' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({hotspot_metric_results: related_results}.to_json))
      end
    end
  end
end
