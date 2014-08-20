require 'rails_helper'

describe NativeMetric, :type => :model do
  describe 'methods' do
    describe 'initialize' do
      context 'with valid attributes' do
        name = "Sample name"
        code = "sample_code"
        scope = Granularity.new(:SOFTWARE)
        languages = [:C, :CPP, :JAVA]
        native_metric = NativeMetric.new(name, code, scope, languages)

        it 'should return an instance of NativeMetric' do
          expect(native_metric).to be_a(NativeMetric)
        end
        it 'should have the right attributes' do #FIXME This test is testing our knowledge of Ruby, delete it at your will.
          expect(native_metric.compound).to be_falsey
          expect(native_metric.name).to eq(name)
          expect(native_metric.code).to eq(code)
          expect(native_metric.scope).to eq(scope)
        end
      end
    end
  end
end