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
        include RunnerMockHelper
        let!(:code_dir) { "/tmp/test" }
        let!(:module_result) { FactoryGirl.build(:module_result) }
        let!(:kalibro_module) {FactoryGirl.build(:kalibro_module) }

        before :each do
          preparing_state_mocks
          downloading_state_mocks
          collecting_state_mocks
          building_state_mocks
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