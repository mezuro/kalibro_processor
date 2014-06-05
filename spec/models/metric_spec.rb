require 'rails_helper'

describe Metric, :type => :model do
  describe 'methods' do
    describe 'initialize' do
      it 'should return an instance of Metric' do
        compound = true
        name = "Sample name"
        scope = Granularity.new(:SOFTWARE)
        expect(Metric.new(compound, name, scope)).to be_a(Metric)
      end
    end
  end
end