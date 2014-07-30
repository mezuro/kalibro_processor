require 'rails_helper'

describe Runner, :type => :model do
  describe 'methods' do
    describe 'run' do
      let(:configuration) { FactoryGirl.build(:configuration) }
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", configuration: configuration) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository) }
      let!(:process_time) { FactoryGirl.build(:process_time) }
      subject { Runner.new(repository, processing) }
      let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
      let!(:compound_metric_configuration) { FactoryGirl.build(:compound_metric_configuration) }


      context 'without cancelling the processing' do
        before :each do
          YAML.expects(:load_file).with("#{Rails.root}/config/repositories.yml").returns({"repositories"=>{"path"=>"/tmp"}})
        end

        context 'when the base directory exists' do
          include RunnerMockHelper
          let!(:code_dir) { "/tmp/test" }
          let!(:root_module_result) { FactoryGirl.build(:module_result) }
          let!(:module_result) { FactoryGirl.build(:module_result_class_granularity) }
          let!(:kalibro_module) {FactoryGirl.build(:kalibro_module) }
          let!(:metric_result) { FactoryGirl.build(:metric_result) }
          let!(:range) { FactoryGirl.build(:range) }
          let!(:reading) { FactoryGirl.build(:reading) }

          before :each do
            preparing_state_mocks
            downloading_state_mocks
            collecting_state_mocks
            building_state_mocks
            aggregating_state_mocks
            calculating_state_mocks
            interpretating_state_mocks
            processing.expects(:update).with(state: "READY")
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

      context 'with a cenceled processing' do
        before :each do
          processing.state = "CANCELED"
        end

        it 'is expected to destroy yhe processing' do
          processing.expects(:destroy)
          subject.run
        end
      end
    end
  end
end