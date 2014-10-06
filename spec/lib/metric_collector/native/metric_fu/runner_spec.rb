require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Runner, :type => :model do
  let!(:repository_path) { Dir.pwd }
  subject { MetricCollector::Native::MetricFu::Runner.new(repository_path: repository_path) }

  describe 'initialize' do
    it 'is expected to have a output_path' do
      expect(MetricCollector::Native::MetricFu::Runner.new(repository_path: repository_path).output_path).to_not be_nil
    end
  end

  describe 'output_path' do
    it 'is expected to generate a path that does not exist' do
      expect(File.exists?(subject.output_path)).to be_falsey
    end
  end

  describe 'run' do
    let(:metric_fu_command) { "metric_fu --format yaml --output #{subject.output_path}" }

    it 'is expected to call the metric_fu command' do
      MetricCollector::Native::MetricFu::Runner.any_instance.expects(:`).with(metric_fu_command).returns(nil)

      subject.run
    end
  end

  describe 'clean_output' do
    context 'when the file exists' do
      before :each do
        File.expects(:exists?).twice.with(subject.output_path).returns(true)
      end

      it 'is expected to call the delete' do
        File.expects(:delete).with(subject.output_path).returns(true)

        subject.clean_output
      end
    end
  end
end