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
end