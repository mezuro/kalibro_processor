require 'rails_helper'

RSpec.describe BaseToolsController, :type => :controller do
  describe 'all_names' do
    let(:names) { ["Analizo"] }
    before :each do
      get :all_names, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'is expected to return the list of base tool names converted to JSON' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({base_tool_names: names}.to_json))
    end
  end

  describe 'find' do
    context 'with a valid base tool' do
      let!(:base_tool) { FactoryGirl.build(:base_tool) }
      before :each do
        AnalizoMetricCollector.expects(:description).returns(base_tool.description)
        AnalizoMetricCollector.expects(:supported_metrics).returns(base_tool.supported_metrics)

        get :find, name: base_tool.name, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'should return the module_result' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({base_tool: base_tool}.to_json))
      end
    end

    context 'with an invalid base tool' do
      let(:base_tool_name) { "BaseTool" }
      let(:error_hash) { {error: Errors::NotFoundError.new("Base tool #{base_tool_name} not found.")} }

      before :each do
        get :find, name: base_tool_name, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'is expected to return the error_hash' do
        expect(JSON.parse(response.body)).to eq(JSON.parse(error_hash.to_json))
      end
    end
  end
end