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
  end
end
