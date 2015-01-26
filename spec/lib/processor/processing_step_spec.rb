require 'rails_helper'
require 'processor'

describe Processor::ProcessingStep do
  describe 'methods' do
    let!(:kalibro_configuration) { FactoryGirl.build(:kalibro_configuration) }
    let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", kalibro_configuration: kalibro_configuration) }
    let!(:processing) { FactoryGirl.build(:processing, repository: repository) }
    let!(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }

    describe 'perform' do
      context 'with a canceled processing' do
        before :each do
          processing.state = "CANCELED"
        end

        it 'is expected to raise a ProcessingCanceledError' do
          expect { Processor::ProcessingStep.perform(context) }.to raise_error(Errors::ProcessingCanceledError)
        end
      end

      context 'with a valid state for performing the task' do
        let!(:state) { "STATE" }
        let!(:process_time) { FactoryGirl.build(:process_time) }

        before :each do
          Processor::ProcessingStep.expects(:state).twice.returns(state)
        end

        it 'is expected to create the processing time and call the task' do
          ProcessTime.expects(:create).with(anything).returns(process_time)
          Processor::ProcessingStep.expects(:task).with(context)
          processing.expects(:update).with(state: state)

          Processor::ProcessingStep.perform(context)
        end
      end
    end
  end
end
