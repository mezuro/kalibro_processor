require 'rails_helper'

RSpec.describe ProcessTime, :type => :model do
  describe 'associations' do
    it {is_expected.to belong_to(:processing)}
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:state) }
  end

  describe "methods" do
    describe "time" do
      subject { FactoryGirl.build(:process_time) }
      it "is expected to return the process time" do
        process_time = subject.updated_at.to_datetime - subject.created_at.to_datetime
        expect( subject.time ).to eq(process_time)
      end
    end

    describe "to_json" do
      subject { FactoryGirl.build(:process_time) }

      it 'is expected to add the time to the JSON' do
        process_time = subject.updated_at.to_datetime - subject.created_at.to_datetime
        expect(JSON.parse(subject.to_json)['time']).to eq(process_time.to_s)
      end

      it 'is expected to preserve all the attributes' do
        expect(JSON.parse(subject.to_json)['state']).to eq(JSON.parse(subject.to_json)['state'])
      end
    end
  end
end
