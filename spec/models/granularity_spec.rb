require 'spec_helper'

describe Granularity do
  describe 'methods' do
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
  end
end