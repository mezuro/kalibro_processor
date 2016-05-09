require 'rails_helper'
require 'metric_collector'

include MetricCollector

describe MetricCollector::KolektiAdapter do
  describe 'method' do
    describe 'available' do
      context 'when all the collectors are available' do
        let(:collector) { FactoryGirl.build(:kolekti_metric_collector) }
        before :each do
          Kolekti.expects(:collectors).returns([collector])
        end

        it 'is expected to return all the collectors' do
          expect(MetricCollector::KolektiAdapter.available).to eq([collector])
        end
      end

      context 'when none of the collectors are available' do
        before :each do
          Kolekti.expects(:collectors).returns([])
        end

        it 'is expected to return an empty list' do
          expect(MetricCollector::KolektiAdapter.available).to be_empty
        end
      end
    end

    describe 'details' do
      let!(:metric_collector) { FactoryGirl.build(:kolekti_metric_collector) }

      before :each do
        MetricCollector::KolektiAdapter.expects(:available).returns([metric_collector])
      end

      it 'is expected to return the details from the given collector' do
        MetricCollector::KolektiAdapter.details.each do |detail|
          expect(detail.name).to eq(metric_collector.name)
          expect(detail.description).to eq(metric_collector.description)
          expect(detail.supported_metrics.first.code).to eq(metric_collector.supported_metrics.first.code)
        end
      end
    end
  end
end
