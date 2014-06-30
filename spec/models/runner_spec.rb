require 'rails_helper'

describe Runner, :type => :model do
  describe 'methods' do
    describe 'run' do
      let(:configuration) { FactoryGirl.build(:configuration) }
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", configuration: configuration) }
      subject { Runner.new(repository) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository) }
      let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
      let!(:compound_metric_configuration) { FactoryGirl.build(:compound_metric_configuration) }

      before :each do
        Processing.expects(:create).returns(processing)
        YAML.expects(:load_file).with("#{Rails.root}/config/repositories.yml").returns({"repositories"=>{"path"=>"/tmp"}})
      end

      context 'when the base directory exists' do
        let!(:code_dir) { "/tmp/test" }

        before :each do
          Dir.expects(:exists?).with("/tmp").at_least_once.returns(true)
          Digest::MD5.expects(:hexdigest).returns("test")
          Dir.expects(:exists?).with(code_dir).returns(false)
          Downloaders::GitDownloader.expects(:retrieve!).with(repository.address, code_dir).returns true
          repository.expects(:configuration).at_least_once.returns(configuration)
          repository_clone = repository.clone
          repository_clone.code_directory = code_dir
          repository.expects(:update).with(code_directory: code_dir).returns(repository_clone)
          KalibroGatekeeperClient::Entities::MetricConfiguration.expects(:metric_configurations_of).
            with(configuration.id).returns([metric_configuration, compound_metric_configuration])
          AnalizoMetricCollector.any_instance.expects(:collect_metrics).with(code_dir, [metric_configuration.code], processing)
        end

        it 'should run' do
          subject.run
          expect(subject.native_metrics[metric_configuration.base_tool_name]).to include(metric_configuration)
          expect(subject.compound_metrics).to include(compound_metric_configuration)
        end
      end

      context 'when the base directory does not exist' do
        before :each do
          Dir.expects(:exists?).with("/tmp").returns(false)
        end

        it 'should raise a RunTimeError exception' do
          expect { subject.run }.to raise_error(RuntimeError)
        end
      end
    end
  end
end