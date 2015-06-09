require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Runner, :type => :model do
  let!(:repository_path) { Dir.pwd }
  #let(:wanted_metrics) { MetricConfigurations }
  subject { MetricCollector::Native::Radon::Runner.new(repository_path: repository_path, wanted_metric_configurations: {}) }

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

  describe 'run' do
    it 'is expected to call the radon command' do
      MetricCollector::Native::Radon::Runner.any_instance.expects(:run_wanted_metrics).returns(nil)
      subject.run_wanted_metrics
    end
  end

  describe 'clean_output' do
    context 'when the file exists' do
      before :each do
        subject.clean_output
      end

      it 'is expected to delete files on repository_path' do
        expect(File.exists?("#{subject.repository_path}/radon_cc_output.json")).to be_falsy
      	expect(File.exists?("#{subject.repository_path}/radon_mi_output.json")).to be_falsy
        expect(File.exists?("#{subject.repository_path}/radon_raw_output.json")).to be_falsy
      end
    end
  end
end