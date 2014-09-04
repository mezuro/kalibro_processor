require 'rails_helper'
require 'metric_collector'

include MetricCollector

describe MetricCollector::Base, :type => :model do
  describe 'method' do
    describe 'collect_metrics' do
      subject { MetricCollector::Base.new("", "", []) }
      it 'should raise a NotImplementedError' do
        expect { subject.collect_metrics("", "") }.to raise_error(NotImplementedError)
      end
    end
  end
end