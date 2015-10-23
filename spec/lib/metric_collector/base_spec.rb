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

    describe 'parse_supported_metrics' do
      subject { MetricCollector::Base.new("", "", []) }
      let(:metrics) { {metrics:
                        {flog:
                          {name: "Pain",
                           description: "",
                           scope: "METHOD",
                           type: "NativeMetricSnapshot"},
                         flay:
                          {name: "Duplicate Code",
                           description: "",
                           scope: "PACKAGE",
                           type: "HotspotMetricSnapshot"}
                        }
                      }
                    }

      before :each do
        YAML.expects(:load_file).with("#{Rails.root}/lib/metric_collector/native/metric_fu/metrics.yml").returns(metrics)
      end

      it 'is expected to return a code => Metric hash' do
        supported_metrics = { flog: FactoryGirl.build(:flog_metric, description: ''),
                              flay: FactoryGirl.build(:flay_metric, description: '') }

        expect(subject.parse_supported_metrics("#{Rails.root}/lib/metric_collector/native/metric_fu/metrics.yml", "MetricFu", [:RUBY])).to eq(supported_metrics)
      end
    end
  end
end