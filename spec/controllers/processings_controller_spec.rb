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
      expect(JSON.parse(response.body)).to eq(JSON.parse({process_times: processing.process_times.map { |process_time| JSON.parse(process_time.to_json) }}.to_json))
    end
  end

  describe 'error_message' do
    let!(:processing_with_error) { FactoryGirl.build(:processing_with_error, id: 1) }

    before :each do
      Processing.expects(:find).with(processing_with_error.id).returns(processing_with_error)
      get :error_message, id: processing_with_error.id, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it 'is expected to return the error message converted to JSON' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({error_message: processing_with_error.error_message}.to_json))
    end


  end
end
