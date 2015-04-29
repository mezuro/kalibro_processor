require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Analizo::Runner, :type => :model do
  describe 'methods' do
    describe 'run' do
      let!(:repository_path) { "app/models/metric.rb" }

      subject{ MetricCollector::Native::Analizo::Runner.new(repository_path: repository_path) }

      context 'when Analizo is not available' do
        before :each do
          subject.expects(:`).with("analizo metrics #{repository_path}").returns(nil)
        end

        it 'is expected to return a NotFoundError' do
          expect {subject.run}.to raise_error(Errors::NotFoundError)
        end
      end

      context 'when there are no results' do
        before :each do
          subject.expects(:`).with("analizo metrics #{repository_path}").returns("")
        end

        it 'is expected to return a NotFoundError' do
          expect {subject.run}.to raise_error(Errors::NotReadableError)
        end
      end

      context 'when Analizo returns results' do
        let!(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list) }

        before :each do
          subject.expects(:`).with("analizo metrics #{repository_path}").returns(analizo_metric_collector_list.raw)
        end

        it 'is expected to return a NotFoundError' do
          expect(subject.run).to eq(analizo_metric_collector_list.raw)
        end
      end
    end
  end
end