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

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
      end
    end
  end

  describe "create" do
    let(:kalibro_module_params) { Hash[FactoryGirl.attributes_for(:kalibro_module).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers

    before :each do
      kalibro_module.id = nil
      kalibro_module_params.delete('id')
    end

    pending 'Waiting for a better fix for Json parameters' do
      context 'with valid params' do
        before :each do
          KalibroModule.any_instance.expects(:save).returns(true)

          post :create, kalibro_module: kalibro_module_params, format: :json
        end

        it { is_expected.to respond_with(:created) }

        it 'is expected to return the kalibro_module created' do
          expect(JSON.parse(response.body)).to eq(JSON.parse({kalibro_module: kalibro_module}.to_json))
        end
      end
    end

    describe "with invalid params" do
      before :each do
        KalibroModule.any_instance.expects(:save).returns(false)

        post :create, kalibro_module: kalibro_module_params, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end

  describe "update" do
    let(:kalibro_module_params) { Hash[FactoryGirl.attributes_for(:kalibro_module).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers

    before :each do
      kalibro_module_params.delete('id')
      KalibroModule.expects(:find).with(kalibro_module.id).returns(kalibro_module)
    end

    describe "with valid params" do
      before :each do
        KalibroModule.any_instance.expects(:save).returns(true)

        put :update, kalibro_module: kalibro_module_params, id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:ok) }

      it 'is expected to return the kalibro_module' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({kalibro_module: kalibro_module}.to_json))
      end
    end

    describe "with invalid params" do
      before :each do
        kalibro_module_params.delete('id')
        KalibroModule.any_instance.expects(:update).with(kalibro_module_params).returns(false)

        put :update, kalibro_module: kalibro_module_params, id: kalibro_module.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end

  describe 'destroy' do
    before :each do
      kalibro_module.expects(:destroy).returns(true)
      KalibroModule.expects(:find).with(kalibro_module.id).returns(kalibro_module)

      delete :destroy, id: kalibro_module.id, format: :json
    end

    it { is_expected.to respond_with(:no_content) }
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
end

