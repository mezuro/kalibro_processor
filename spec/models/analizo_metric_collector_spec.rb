require 'spec_helper'

describe AnalizoMetricCollector do
  describe 'methods' do
    describe 'name' do
      it 'should return Analizo' do
        subject.name.should eq("Analizo")
      end
    end

    describe 'description' do

      before :each do
        CollectorsDescriptions.expects(:analizo_description).returns(String.new)
      end

      it 'should return the content of the analizo_descritption file' do
        subject.description.should be_a(String)
      end
    end
  end
end