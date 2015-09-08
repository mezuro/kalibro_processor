require 'rails_helper'
require 'processor'

describe Processor::Preparer do
  describe 'methods' do
    let!(:code_dir) { "/tmp/test" }
    let!(:kalibro_configuration) { FactoryGirl.build(:kalibro_configuration) }
    let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", kalibro_configuration: kalibro_configuration) }
    let!(:processing) { FactoryGirl.build(:processing, repository: repository, process_times: FactoryGirl.build_stubbed_list(:process_time, 1)) }
    let!(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }
    let!(:metric_configuration) { FactoryGirl.build(:metric_configuration, metric: FactoryGirl.build(:acc_metric)) }
    let!(:compound_metric_configuration) { FactoryGirl.build(:compound_metric_configuration) }
    let!(:dir) { YAML.load_file("#{Rails.root}/config/repositories.yml")["repositories"]["path"] }

    describe 'task' do
      before :each do
        processing.process_times.expects(:destroy_all).once
      end

      context 'when the base directory exists' do
        before :each do
          repository.expects(:update).with(code_directory: code_dir)
          repository.expects(:kalibro_configuration).returns(kalibro_configuration)
          Dir.expects(:exists?).with(dir).at_least_once.returns(true)
          Digest::MD5.expects(:hexdigest).returns("test")
          Dir.expects(:exists?).with(code_dir).returns(false)
          KalibroClient::Entities::Configurations::MetricConfiguration.expects(:metric_configurations_of).
            with(kalibro_configuration.id).returns([metric_configuration, compound_metric_configuration])
        end

        it 'is expected to accomplish the preparing state of a process successfully' do
          Processor::Preparer.task(context)
        end
      end

      context 'when the base directory does not exist' do
        before :each do
          Dir.expects(:exists?).with(dir).returns(false)
        end

        it 'is expected to raise a RunTimeError exception' do
          expect { Processor::Preparer.task(context) }.to raise_error(Errors::ProcessingError, "Repository's directory (#{dir}) does not exist")
        end
      end
    end

    describe 'state' do
      it 'is expected to return "PREPARING"' do
        expect(Processor::Preparer.state).to eq("PREPARING")
      end
    end
  end
end
