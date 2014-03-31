require 'spec_helper'

describe Language do
  describe 'methods' do
    subject { FactoryGirl.build(:language) }
    describe 'language' do 
      context 'with an existing language name' do
        it 'should return a language name' do
          subject.language.should_not be_nil
        end
      end
    end
  end
end