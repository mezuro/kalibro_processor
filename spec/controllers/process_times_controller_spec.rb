require 'rails_helper'

RSpec.describe ProcessTimesController, :type => :controller do
  let(:process_time) { FactoryGirl.build(:process_time) }

  describe "index" do
    before :each do
      ProcessTime.expects(:all).returns([process_time])

      get :index, format: :json
    end

    it { is_expected.to respond_with(:success) }

    it "converts all process_times to JSON" do
      expect(JSON.parse(response.body)).to eq(JSON.parse({process_time: [process_time]}.to_json))
    end
  end

  describe "show" do
    describe 'when exists a process_time with the given id' do
      before :each do
        ProcessTime.expects(:find).with(process_time.id).returns(process_time)

        get :show, id: process_time.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it "returns a process_time converted to JSON" do
        expect(JSON.parse(response.body)).to eq(JSON.parse({process_time: process_time}.to_json))
      end
    end

    describe 'when there are no process_times with the given id' do
      before :each do
        ProcessTime.expects(:find).with(process_time.id).raises(ActiveRecord::RecordNotFound)

        get :show, id: process_time.id, format: :json
      end

      it { is_expected.to respond_with(:not_found) }

      it 'should return the error description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
      end
    end
  end

  describe 'processings' do
    let(:processing) { FactoryGirl.build(:processing) }

    before :each do
      ProcessTime.expects(:find).with(process_time.id).returns(process_time)
      process_time.expects(:processing).returns(processing)
      get :processing, process_time: process_time, id: process_time.id, format: :json
    end

    it { is_expected.to respond_with(:ok) }

    it 'is expected to return the processing' do
      expect(JSON.parse(response.body)).to eq(JSON.parse({processing: processing}.to_json))
    end
  end
end
