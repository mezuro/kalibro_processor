require 'rails_helper'

describe Granularity, :type => :model do
  describe 'method' do
    describe 'is_valid?' do
      it 'should accept all the items on the GRANULARITIES constant' do
        Granularity::GRANULARITIES.each do |granularity|
          expect(Granularity.is_valid?(granularity)).to be_truthy
        end
      end

      it 'should not accept :MQQ' do
        expect(Granularity.is_valid?(:MQQ)).to be_falsey
      end
    end

    describe 'initialize' do
      context 'with a valid type' do
        it 'should return an instance of Granularity' do
          expect(Granularity.new(:SOFTWARE)).to be_a(Granularity)
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
          expect(subject.parent.type).to eq(Granularity::SOFTWARE)
        end
      end

      context 'with a SOFTWARE granularity' do
        subject { FactoryGirl.build(:granularity, type: Granularity::METHOD) }

        it 'should return CLASS' do
          expect(subject.parent.type).to eq(Granularity::CLASS)
        end
      end
    end

    describe '<=' do
      subject { FactoryGirl.build(:granularity, type: Granularity::CLASS) }
      context 'comparing to a greater one' do
        let(:other_granularity) { FactoryGirl.build(:granularity, type: Granularity::SOFTWARE) }
        it 'should return true' do
          expect(subject <= other_granularity).to be_truthy
        end
      end
      context 'comparing to an equal one' do
        let(:other_granularity) { FactoryGirl.build(:granularity, type: Granularity::CLASS) }
        it 'should return true' do
          expect(subject <= other_granularity).to be_truthy
        end
      end
      context 'comparing to a smaller one' do
        let(:other_granularity) { FactoryGirl.build(:granularity, type: Granularity::METHOD) }
        it 'should return false' do
          expect(subject <= other_granularity).to be_falsey
        end
      end
    end

    describe '<' do
      subject { FactoryGirl.build(:granularity, type: Granularity::CLASS) }
      context 'comparing to a greater one' do
        let(:other_granularity) { FactoryGirl.build(:granularity, type: Granularity::CLASS) }
        it 'should return false' do
          expect(subject < other_granularity).to be_falsey
        end
      end
    end

    describe '>' do
      subject { FactoryGirl.build(:granularity, type: Granularity::CLASS) }
      context 'comparing to a greater one' do
        let(:other_granularity) { FactoryGirl.build(:granularity, type: Granularity::SOFTWARE) }
        it 'should return false' do
          expect(subject > other_granularity).to be_falsey
        end
      end
    end
  end
end
