require 'rails_helper'

describe Metric, :type => :model do
  describe 'methods' do
    describe 'initialize' do
      it 'should return an instance of Metric' do
        compound = true
        name = "Sample name"
        code = "sample_code"
        scope = Granularity.new(:SOFTWARE)
        expect(Metric.new(compound, name, code, scope)).to be_a(Metric)
      end
    end
  end
end