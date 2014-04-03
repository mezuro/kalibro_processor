require 'spec_helper'

describe NativeMetric do
  describe 'methods' do
    describe 'initialize' do
      context 'with valid attributes' do
        name = "Sample name"
        scope = Granularity.new(:SOFTWARE)
        languages = [Language.new(:C), Language.new(:CPP), Language.new(:JAVA)]
        native_metric = NativeMetric.new(name, scope, languages)
        
        it 'should return an instance of NativeMetric' do
          native_metric.should be_a(NativeMetric)
        end
        it 'should have the right attributes' do #FIXME This test is testing our knowledge of Ruby, delete it at your will.
          native_metric.compound.should be_false
          native_metric.name.should eq(name)
          native_metric.scope.should eq(scope)
        end
      end
    end
  end
end 