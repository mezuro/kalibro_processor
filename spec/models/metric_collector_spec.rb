require 'rails_helper'

describe MetricCollector, :type => :model do
  describe 'method' do
    describe 'description' do
      it 'should raise a NotImplementedError' do
        expect { subject.description }.to raise_error(NotImplementedError)
      end
    end

    describe 'supported_metrics' do
      it 'should raise a NotImplementedError' do
        expect { subject.supported_metrics }.to raise_error(NotImplementedError)
      end
    end

    describe 'collect_metrics' do
      it 'should raise a NotImplementedError' do
        expect { subject.collect_metrics("", "") }.to raise_error(NotImplementedError)
      end
    end
  end
end