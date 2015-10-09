require 'rails_helper'

RSpec.describe MetricResultsController, :type => :controller do
  describe 'module_result' do
    context 'with a valid MetricResult id' do
      let!(:metric_result) { FactoryGirl.build(:metric_result, :with_id) }
      let!(:module_result) { FactoryGirl.build(:module_result) }

      before :each do
        metric_result.module_result = module_result
        MetricResult.expects(:find).with(metric_result.id).returns(metric_result)

        get :module_result, id: metric_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'is expected to return the associated ModuleResult json' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({module_result: module_result}.to_json))
      end
    end

    context 'with a invalid MetricResult id' do
      let!(:invalid_id) { 42 }

      before :each do
        MetricResult.expects(:find).with(invalid_id).raises(ActiveRecord::RecordNotFound)

        get :module_result, id: invalid_id, format: :json
      end

      it { is_expected.to respond_with(:not_found) }
    end
  end
end