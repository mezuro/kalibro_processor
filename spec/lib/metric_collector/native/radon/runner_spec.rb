require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Runner, :type => :model do
  let!(:repository_path) { Dir.pwd }
  let(:wanted_metrics) { [FactoryGirl.build(:cyclomatic_configuration),FactoryGirl.build(:maintainability_configuration),FactoryGirl.build(:lines_of_code_configuration)] }
  subject { MetricCollector::Native::Radon::Runner.new(repository_path: repository_path, wanted_metric_configurations: wanted_metrics) }

  describe 'initialize' do
    it 'is expected to have a repository_path' do
      expect(MetricCollector::Native::Radon::Runner.new(repository_path: repository_path).repository_path).to_not be_nil
    end
  end

  describe 'repository_path' do
    it 'is expected to generate a path that does not exist' do
      expect(File.exists?(subject.repository_path)).to be_truthy
    end
  end

  describe 'run_wanted_metrics' do
    it 'is expected to call the radon command' do
      subject.run_wanted_metrics
    end
  end

  describe 'clean_output' do
    context 'when the file exists' do
      it 'is expected to delete files on repository_path' do
        subject.clean_output
      end
    end
  end
end