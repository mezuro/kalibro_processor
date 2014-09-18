require 'rails_helper'


# FIXME: Rewrite this after rspec gets support to ActiveJob
describe RunnerJob, :type => :job do
  # GLobalID tries to serialize the objects and then find them by id.
  let!(:processing) { FactoryGirl.build(:processing, id: 1) }
  let!(:repository) { FactoryGirl.build(:repository, id: 1) }
  let(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }

  # GLobalID tries to serialize the objects and then find them.
  # This may get fixed on a new version of RSpec compatible with Rails 4.2
  before :each do
    Repository.expects(:find).with(repository.id.to_s).returns(repository)
    Processing.expects(:find).with(processing.id.to_s).returns(processing)
  end

  describe 'methods' do
    describe 'perform' do
      context 'when the process is not cancelled' do
        let!(:process_time) { FactoryGirl.build(:process_time) }

        before :each do
          Processor::Preparer.expects(:perform)
          Processor::Downloader.expects(:perform)
          Processor::Collector.expects(:perform)
          Processor::TreeBuilder.expects(:perform)
          Processor::Aggregator.expects(:perform)
          Processor::CompoundResultCalculator.expects(:perform)
          Processor::Interpreter.expects(:perform)
        end

        it 'should run' do
          RunnerJob.perform_later(repository, processing)
        end
      end

      context 'with a canceled processing' do
        before :each do
          processing.state = "CANCELED"
        end

        it 'is expected to destroy the processing' do
          processing.expects(:destroy)
          RunnerJob.perform_later(repository, processing)
        end
      end

      context 'with a failed step' do
        let!(:error_message) { 'Error message' }
        before :each do
          Processor::Preparer.expects(:perform).raises(Errors::ProcessingError, error_message)
        end

        it 'is expected to update the processing state to ERROR' do
          processing.expects(:update).with(state: 'ERROR', error_message: error_message)

          RunnerJob.perform_later(repository, processing)
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
