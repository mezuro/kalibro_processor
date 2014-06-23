require 'rails_helper'

RSpec.describe Processing, :type => :model do
  describe 'method' do
    describe 'get_state' do
      context 'without ERROR state' do
        before :each do
          subject.expects(:set_state).with(subject.state).returns(subject.state)
        end

        it 'should return a valid process state' do
          expect(subject.set_state).to eq(subject.state)
        end
      end

     pending context 'with ERROR state' do
        let(:process_time) { FactoryGirl.build(:process_time) }
        let!(:processing) { FactoryGirl.build(:processing, state: "ERROR", process_time: process_time) }
        before :each do
          processing.expects(:set_state).with(processing.state).returns(processing.state)
        end

        it 'should raise an error' do
          expect(subject.set_state).to raise_error(Errors::ProcessingError, "Processing Error")
        end

      end
    end
  end
end