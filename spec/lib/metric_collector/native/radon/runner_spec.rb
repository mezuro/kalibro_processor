require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Runner, :type => :model do
  let!(:repository_path) { Dir.pwd }
  let(:wanted_metrics) { [FactoryGirl.build(:cyclomatic_metric_configuration),FactoryGirl.build(:maintainability_metric_configuration),FactoryGirl.build(:lines_of_code_configuration)] }
  subject { MetricCollector::Native::Radon::Runner.new(repository_path: repository_path, wanted_metric_configurations: wanted_metrics) }

  describe 'initialize' do
    it 'is expected to have a repository_path' do
      expect(MetricCollector::Native::Radon::Runner.new(repository_path: repository_path)).to_not be_nil
    end
  end

  describe 'run_wanted_metrics' do
    it 'is expected to run wanted metrics' do
      MetricCollector::Native::Radon::MetricRunners::Cyclomatic.expects(:run).returns(0)
      MetricCollector::Native::Radon::MetricRunners::Maintainability.expects(:run).returns(0)
      MetricCollector::Native::Radon::MetricRunners::Raw.expects(:run).returns(0)

      expect(subject.run_wanted_metrics).to eql(wanted_metrics)
    end
  end

  describe 'clean_output' do
    it 'is expected to delete files on repository_path' do
      expect(subject.clean_output).to eql(wanted_metrics)
    end
  end
end