require 'spec_helper'

describe Language do
  describe 'method' do
    describe 'initialize' do
      context 'with valid type' do
        it 'should initialize successfully' do
          language = Language.new(:C)
          language.type.should_not be_nil
        end
      end

      context 'with invalid type' do
        it 'should raise an exception' do
          language = Language.new(:Type)
          expect { raise TypeError}.to raise TypeError
        end
      end
    end

    describe 'is_valid?' do
      context 'with nil type' do
        it 'should return false' do
          Language.is_valid?(nil).should be_false
        end
      end

      context 'with not supported type' do
        it 'should return false' do
          Language.is_valid?(:Type).should be_false
        end
      end

      context 'with supported type' do
        it 'should return true' do
          Language.is_valid?(:C).should be_true
        end
      end
    end
  end
end
