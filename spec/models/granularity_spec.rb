require 'spec_helper'

describe Granularity do
  describe 'method' do
    describe 'is_valid?' do
      it 'should accept all the items on the GRANULARITIES constant' do
        Granularity::GRANULARITIES.each do |granularity|
          Granularity.is_valid?(granularity).should be_true
        end
      end

      it 'should not accept :MQQ' do
        Granularity.is_valid?(:MQQ).should be_false
      end
    end

    describe 'initialize' do
      context 'with a valid type' do
        it 'should return an instance of Granularity' do
          Granularity.new(:SOFTWARE).should be_a(Granularity)
        end
      end

      context 'with a invalid type' do
        it 'should raise a TypeError' do
          expect { Granularity.new(:MCC) }.to raise_error(TypeError)
        end
      end
    end

    describe 'parent' do
      context 'with a SOFTWARE granularity' do
        subject { FactoryGirl.build(:granularity) }

        it 'should return SOFTWARE' do
          subject.parent.type.should eq(Granularity::SOFTWARE)
        end
      end

      context 'with a SOFTWARE granularity' do
        subject { FactoryGirl.build(:granularity, type: Granularity::METHOD) }

        it 'should return CLASS' do
          subject.parent.type.should eq(Granularity::CLASS)
        end
      end
    end
  end
end