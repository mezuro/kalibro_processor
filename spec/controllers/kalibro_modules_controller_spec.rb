require 'rails_helper'

RSpec.describe KalibroModulesController, :type => :controller do
  let(:kalibro_module) { FactoryGirl.build(:kalibro_module_with_id) }

  describe "index" do
    before :each do
      KalibroModule.expects(:all).returns([kalibro_module])

      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it "converts all kalibro_modules to JSON" do
      expect(JSON.parse(response.body)).to eq(JSON.parse({kalibro_module: [kalibro_module]}.to_json))
    end
  end

  describe "show" do
    describe 'when exists a kalibro_module with the given id' do
      before :each do
        KalibroModule.expects(:find).with(kalibro_module.id).returns(kalibro_module)

        get :show, id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it "returns a kalibro_module converted to JSON" do
        expect(JSON.parse(response.body)).to eq(JSON.parse({kalibro_module: kalibro_module}.to_json))
      end
    end

    describe 'when there are no kalibro_modules with the given id' do
      before :each do
        KalibroModule.expects(:find).with(kalibro_module.id).raises(ActiveRecord::RecordNotFound)

        get :show, id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:not_found) }

      it 'should return the error description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
      end
    end
  end

  describe 'module_results' do
    let(:module_result) { FactoryGirl.build(:module_result_with_kalibro_module_with_id) }
    let(:kalibro_module) { module_result.kalibro_module }

    before :each do
      KalibroModule.expects(:find).with(kalibro_module.id).returns(kalibro_module)
      kalibro_module.expects(:module_results).returns([module_result])
      get :module_results, id: kalibro_module.id, format: :json
    end

    it { is_expected.to respond_with(:ok) }

    it 'is expected to return the module_results' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({module_results: [module_result]}.to_json))
    end
  end


  describe 'exists' do
    let(:kalibro_module) { FactoryGirl.build(:kalibro_module_with_id) }

    context 'when the kalibro module exists' do
      before :each do
        KalibroModule.expects(:exists?).with(kalibro_module.id).returns(true)

        get :exists, id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return true' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: true}.to_json))
      end
    end

    context 'when the kalibro module does not exist' do
      before :each do
        KalibroModule.expects(:exists?).with(kalibro_module.id).returns(false)

        get :exists, id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return false' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({exists: false}.to_json))
      end
    end
  end
end
