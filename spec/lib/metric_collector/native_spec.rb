require 'rails_helper'
require 'metric_collector'

include MetricCollector

describe MetricCollector::Native do
  describe 'method' do
    describe 'available' do
      context 'when all the collectors are available' do
        before :each do
          MetricCollector::Native::ALL.each do |name, collector|
            collector.expects(:available?).returns(true)
          end
        end

        it 'is expected to return all the collectors' do
          expect(MetricCollector::Native.available).to eq(MetricCollector::Native::ALL)
        end
      end

      context 'when none of the collectors are available' do
        before :each do
          MetricCollector::Native::ALL.each do |name, collector|
            collector.expects(:available?).returns(false)
          end
        end

        it 'is expected to return all the collectors' do
          expect(MetricCollector::Native.available).to be_empty
        end
      end
    end

    describe 'details' do
      let!(:metric_collector) { FactoryGirl.build(:native_metric_collector) }

      before :each do
        MetricCollector::Native.expects(:available).returns({metric_collector.details.name => metric_collector.class})
      end

      it 'is expected to return the details from the given collector' do
        MetricCollector::Native.details.each do | collector |
          expect(collector.name).to eq(metric_collector.details.name)
          expect(collector.description).to eq(metric_collector.details.description)
          expect(collector.supported_metrics.first.code).to eq(metric_collector.details.supported_metrics.first.code)
        end
      end
    end
  end
end