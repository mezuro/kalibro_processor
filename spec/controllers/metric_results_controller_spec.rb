require 'rails_helper'

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

        it { is_expected.to respond_with(:success) }

        it 'returns the list of values' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({descendant_values: [metric_result.value]}.to_json))
        end
      end
    end
  end

  describe 'repository_id' do
    let(:metric_result) { FactoryGirl.build(:metric_result, id: 1) }
    let(:processing) { FactoryGirl.build(:processing) }
    let(:repository) { FactoryGirl.build(:repository, id: 2) }

    context 'with valid ModuleResult instance' do
      before :each do
        MetricResult.expects(:find).with(metric_result.id.to_s).returns(metric_result)
        metric_result.expects(:processing).returns(processing)
        processing.expects(:repository).returns(repository)
        post :repository_id, id: metric_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return the repository_id' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({repository_id: repository.id}.to_json))
      end
    end

    context 'with invalid ModuleResult instance' do
      let(:error_hash) { {error: 'RecordNotFound'} }

      before :each do
        MetricResult.expects(:find).with(metric_result.id.to_s).raises(ActiveRecord::RecordNotFound)

        post :repository_id, id: metric_result.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error_hash' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
      end
    end
  end

  describe 'metric_configuration' do
    let!(:metric_result) { FactoryGirl.build(:metric_result, id: 1) }

    context 'with valid ModuleResult instance' do
      pending 'Active Resource does not support to_json method' do
        let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
        before :each do
          MetricResult.expects(:find).with(metric_result.id.to_s).returns(metric_result)
          metric_result.expects(:metric_configuration).returns(metric_configuration)
          get :metric_configuration, id: metric_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the metric configuration' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({metric_configuration: metric_configuration}.to_json))
        end
      end
    end

    context 'with invalid ModuleResult instance' do
      let(:error_hash) { {error: 'RecordNotFound'} }

      before :each do
        MetricResult.expects(:find).with(metric_result.id.to_s).raises(ActiveRecord::RecordNotFound)

        get :metric_configuration, id: metric_result.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error_hash' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
      end
    end
  end
end
