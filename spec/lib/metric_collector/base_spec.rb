require 'rails_helper'
require 'metric_collector'

include MetricCollector

describe MetricCollector::Base, :type => :model do
  describe 'method' do
    describe 'run_if_available' do
      let(:command) { 'ls' }
      let(:command_out) { '.' }

      context 'when the command exists' do
        before :each do
          MetricCollector::Base.expects(:`).with(command).returns(command_out)
        end

        it 'is expected to return the command output' do
          expect(MetricCollector::Base.run_if_available(command)).to eq(command_out)
        end
      end

      context 'when the command does not exists' do
        before :each do
          MetricCollector::Base.expects(:`).with(command).raises(Errno::ENOENT)
        end

        it 'is expected to return nil' do
          expect(MetricCollector::Base.run_if_available(command)).to be_nil
        end
      end
    end

    describe 'collect_metrics' do
      subject { MetricCollector::Base.new("", "", []) }
      it 'should raise a NotImplementedError' do
        expect { subject.collect_metrics("", "") }.to raise_error(NotImplementedError)
      end
    end

    describe 'available?' do
      it 'is expected to raise NotImplementedError' do
        expect { MetricCollector::Base.available? }.to raise_error(NotImplementedError)
      end
    end
  end
end