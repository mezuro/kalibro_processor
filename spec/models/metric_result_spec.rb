require 'spec_helper'

describe MetricResult do
  describe 'method' do
    describe 'initialize' do
      it 'should return an instance of Metric Result' do
        metric = 
        metric_configuration = 
        value = 1.3 #A sample value
        @error = error


        compound = true
        name = "Sample name"
        scope = Granularity.new(:SOFTWARE)
        Metric.new(compound, name, scope).should be_a(Metric)
      end
    end
  end
end