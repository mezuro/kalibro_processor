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

      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'should return the error description' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({error: 'RecordNotFound'}.to_json))
      end
    end
  end

  describe "create" do
    let(:process_time_params) { Hash[FactoryGirl.attributes_for(:process_time).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers

    before :each do
      process_time.id = nil
      process_time_params.delete('id')
    end

    context 'with valid params' do
      before :each do
        ProcessTime.any_instance.expects(:save).returns(true)

        post :create, process_time: process_time_params, format: :json
      end

      it { is_expected.to respond_with(:created) }

      it 'is expected to return the process_time created' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({process_time: process_time}.to_json))
      end
    end

    describe "with invalid params" do
      before :each do
        ProcessTime.any_instance.expects(:save).returns(false)

        post :create, process_time: process_time_params, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end

  describe "update" do
    let(:process_time_params) { Hash[FactoryGirl.attributes_for(:process_time).map { |k,v| [k.to_s, v.to_s] }] } #FIXME: Mocha is creating the expectations with strings, but FactoryGirl returns everything with symbols and integers

    before :each do
      process_time_params.delete('id')
      ProcessTime.expects(:find).with(process_time.id).returns(process_time)
    end

    describe "with valid params" do
      before :each do
        ProcessTime.any_instance.expects(:save).returns(true)

        put :update, process_time: process_time_params, id: process_time.id, format: :json
      end

      it { is_expected.to respond_with(:ok) }

      it 'is expected to return the process_time' do
        expect(JSON.parse(response.body)).to eq(JSON.parse({process_time: process_time}.to_json))
      end
    end

    describe "with invalid params" do
      before :each do
        process_time_params.delete('id')
        ProcessTime.any_instance.expects(:update).with(process_time_params).returns(false)

        put :update, process_time: process_time_params, id: process_time.id, format: :json
      end

      it { is_expected.to respond_with(:unprocessable_entity) }
    end
  end

  describe 'destroy' do
    before :each do
      process_time.expects(:destroy).returns(true)
      ProcessTime.expects(:find).with(process_time.id).returns(process_time)

      delete :destroy, id: process_time.id, format: :json
    end

    it { is_expected.to respond_with(:no_content) }
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
