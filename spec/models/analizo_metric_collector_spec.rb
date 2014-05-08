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

    describe 'metric_list' do
      context 'when the collector is installed on the computer' do
        it "should return all the collector's metrics not parsed" do
          subject.metric_list.should be_a(String)
        end
      end

      pending 'is it better to return nil or to raise an exception?' do
        context 'when the collector is not installed on the computer' do
          it 'should return something' do
          end
        end
      end
    end
  end
end