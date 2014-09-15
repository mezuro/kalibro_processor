require 'rails_helper'

describe RunnerJob, :type => :model do
  let(:processing) { FactoryGirl.build(:processing) }
  let(:repository) { FactoryGirl.build(:repository) }
  let(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }

  pending 'lacks rails update' do
  describe 'methods' do
    describe 'run' do
      context 'when the process is not cancelled' do
        let!(:process_time) { FactoryGirl.build(:process_time) }

        before :each do
          Processor::Preparer.expects(:perform).with(context)
          Processor::Downloader.expects(:perform).with(context)
          Processor::Collector.expects(:perform).with(context)
          Processor::TreeBuilder.expects(:perform).with(context)
          Processor::Aggregator.expects(:perform).with(context)
          Processor::CompoundResultCalculator.expects(:perform).with(context)
          Processor::Interpreter.expects(:perform).with(context)
        end

        it 'should run' do
          RunnerJob.perform(repository, processing)
        end
      end

      context 'with a canceled processing' do
        before :each do
          processing.state = "CANCELED"
        end

        it 'is expected to destroy yhe processing' do
          processing.expects(:destroy)
          RunnerJob.perform(repository, processing)
        end
      end

      context 'with a failed step' do
        let!(:error_message) { 'Error message' }
        before :each do
          Processor::Preparer.expects(:perform).with(context).raises(Errors::ProcessingError, error_message)
        end

        it 'is expected to update the processing state to ERROR' do
          processing.expects(:update).with(state: 'ERROR', error_message: error_message)

          RunnerJob.perform(repository, processing)
        end
      end

      context 'with empty module_results' do
        before :each do
          Processor::Preparer.expects(:perform).with(subject)
          Processor::Downloader.expects(:perform).with(subject)
          Processor::Collector.expects(:perform).with(subject).raises(Errors::EmptyModuleResultsError)
        end
        it 'is expected to update the processing state to READY' do
          processing.expects(:update).with(state: 'READY')

          subject.run
        end
      end
    end
  end
  end
end
