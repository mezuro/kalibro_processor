require 'rails_helper'

RSpec.describe ProcessingsController, :type => :controller do
  let!(:processing) { FactoryGirl.build(:processing, id: 1) }

  describe 'process_times' do
    before :each do
      Processing.expects(:find).with(processing.id).returns(processing)

      get :process_times, id: processing.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'is expected to return the list of process_times converted to JSON' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({process_times: processing.process_times}.to_json))
    end
  end
end
