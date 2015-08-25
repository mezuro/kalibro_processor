require 'rails_helper'
require 'mocha/test_unit'


RSpec.describe HotspotResult, type: :model do
  describe 'relations' do
    subject { FactoryGirl.build(:hotspot_result) }
    let(:other_hotspot_result) { FactoryGirl.build(:hotspot_result) }

    before :each do
      subject.stubs(:related_results).returns(mock())
      other_hotspot_result.stubs(:related_results).returns(mock())

      subject.expects(:transaction).yields
    end

    describe 'add_relation' do
      it 'should create the relation on both sides' do
        subject.related_results.expects(:<<).with(other_hotspot_result)
        other_hotspot_result.related_results.expects(:<<).with(subject)

        subject.add_relation(other_hotspot_result)
      end
    end

    describe 'remove_relation' do
      it 'should remove the relation on both sides' do
        subject.related_results.expects(:delete).with(other_hotspot_result)
        other_hotspot_result.related_results.expects(:delete).with(subject)

        subject.remove_relation(other_hotspot_result)
      end
    end
  end
end
