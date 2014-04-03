require 'spec_helper'

describe Metric do
  describe 'methods' do
    describe 'initialize' do
      it 'should return an instance of Metric' do
        compound = true
        name = "Sample name"
        scope = Granularity.new(:SOFTWARE)
        Metric.new(compound, name, scope).should be_a(Metric)
      end
    end
  end
end 