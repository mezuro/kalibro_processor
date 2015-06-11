require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::MetricRunners::Maintainability, :type => :model do
  let!(:repository_path) { Dir.pwd }
  subject { MetricCollector::Native::Radon::MetricRunners::Maintainability}

  describe 'run' do
    before :each do
      subject.run(repository_path)
    end

    it 'is expected to create cc json file' do
      expect(File.exists?("#{repository_path}/radon_mi_output.json")).to be_truthy
    end
  end

  describe 'clean_output' do
    context 'when the file exists' do
      before :each do
        subject.clean_output
      end

      it 'is expected to delete files on repository_path' do
        expect(File.exists?("#{repository_path}/radon_mi_output.json")).to be_falsy
      end
    end
  end
end