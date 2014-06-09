require 'spec_helper'

describe ModuleResultsController do
  describe 'method' do
    describe 'get' do
      let!(:module_result) { FactoryGirl.build(:module_result, id: 1) }
      
      before :each do
        ModuleResult.expects(:find).with(module_result.id.to_s).returns(module_result)
      end

      context 'with valid ModuleResult instance' do
        before :each do
          post :get, id: module_result.id, format: :json
        end

        it { should respond_with(:success) }
        
        it 'returns the module_result' do
          JSON.parse(response.body).should eq(JSON.parse({module_result: module_result}.to_json))
        end

      end
      
      context 'with invalid ModuleResult instance' do
        it "should respond with success"
        it "should return a :unprocessable_entity status"
      end
    end
  end
end
