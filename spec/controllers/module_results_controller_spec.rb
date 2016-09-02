require 'rails_helper'

describe ModuleResultsController do
  let(:module_result) { FactoryGirl.build(:module_result_with_id) }
  let(:error_hash) { {errors: 'RecordNotFound'} }

  describe 'method' do
    describe 'get' do
      context 'with valid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)

          post :get, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the module_result' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({ module_result: module_result}.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).raises(ActiveRecord::RecordNotFound)

          post :get, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end

    describe 'kalibro_module' do
      context 'when there is a kalibro module' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)

          get :kalibro_module, id: module_result.id, format: :json
        end

        it 'is expected to return a kalibro module' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({ kalibro_module: module_result.kalibro_module}.to_json))
        end
      end

      context 'when there is no kalibro module' do
        before :each do
          module_result.kalibro_module = nil
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)

          get :kalibro_module, id: module_result.id, format: :json
        end

        it 'is expected to return nil' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({ kalibro_module: module_result.kalibro_module}.to_json))
        end
      end
    end

    describe 'metric_results' do
      context 'with valid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)

          post :metric_results, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the metric_results' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({ tree_metric_results: module_result.tree_metric_results }.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).raises(ActiveRecord::RecordNotFound)

          post :metric_results, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end

    describe 'hotspot_metric_results' do
      context 'with valid ModuleResult instance' do
        let!(:hotspot_metric_results) { [FactoryGirl.build(:hotspot_metric_result)] }

        before :each do
          module_result.expects(:descendant_hotspot_metric_results).returns(hotspot_metric_results)
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)

          get :hotspot_metric_results, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the hotspot_metric_results' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({ hotspot_metric_results: hotspot_metric_results }.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).raises(ActiveRecord::RecordNotFound)

          get :hotspot_metric_results, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end

    describe 'descendant_hotspot_metric_results' do
      let(:hotspot_metric_results) { FactoryGirl.build_list(:hotspot_metric_result, 2, :with_id) }

      context 'with valid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)
          module_result.expects(:descendant_hotspot_metric_results).returns(hotspot_metric_results)

          get :descendant_hotspot_metric_results, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the descendant hotspot metric result' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({hotspot_metric_results: hotspot_metric_results}.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).raises(ActiveRecord::RecordNotFound)

          get :descendant_hotspot_metric_results, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end

    describe 'children' do
      let(:module_result_with_parent) { FactoryGirl.build(:module_result, id: 2, kalibro_module: FactoryGirl.build(:kalibro_module)) }

      context 'with valid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)
          module_result_with_parent.parent = module_result
          module_result.children << module_result_with_parent

          post :children, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the children' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({module_results: [module_result_with_parent]}.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).raises(ActiveRecord::RecordNotFound)

          post :children, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end

    describe 'repository_id' do
      let(:processing) { FactoryGirl.build(:processing) }
      let(:repository) { FactoryGirl.build(:repository, id: 2) }

      context 'with valid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).returns(module_result)
          module_result.expects(:processing).returns(processing)
          processing.expects(:repository).returns(repository)
          post :repository_id, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:success) }

        it 'should return the repository_id' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({repository_id: repository.id}.to_json))
        end
      end

      context 'with invalid ModuleResult instance' do
        before :each do
          ModuleResult.expects(:find).with(module_result.id).raises(ActiveRecord::RecordNotFound)

          post :repository_id, id: module_result.id, format: :json
        end

        it { is_expected.to respond_with(:not_found) }

        it 'should return the error_hash' do
          expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
        end
      end
    end
  end

  describe 'exists' do
    context 'when the module result exists' do
      before :each do
        ModuleResult.expects(:exists?).with(module_result.id).returns(true)

        get :exists, id: module_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return true' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end

    context 'when the module_result does not exist' do
      before :each do
        ModuleResult.expects(:exists?).with(module_result.id).returns(false)

        get :exists, id: module_result.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: false}.to_json))
      end
    end
  end
end
