require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::MetricRunners::Raw, :type => :model do
  let!(:repository_path) { Dir.pwd }
  subject { MetricCollector::Native::Radon::MetricRunners::Raw}

  describe 'run' do
    it 'is expected to run raw radon metric collector' do
      Dir.expects(:chdir).with(repository_path).returns(0)

      expect(subject.run(repository_path)).to eql(0)
    end
  end

  describe 'clean_output' do
    it 'is expected to delete raw files on repository_path' do
      File.expects(:exists?).returns(true)
      File.expects(:delete).returns(1)

      expect(subject.clean_output).to eql(1)
    end
  end
end