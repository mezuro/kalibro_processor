require 'rails_helper'

describe Runner, :type => :model do
  let!(:processing) { FactoryGirl.build(:processing) }
  let!(:repository) { FactoryGirl.build(:repository) }
  subject { Runner.new(repository, processing) }
  describe 'methods' do
    describe 'run' do

      context 'when the process is not cancelled' do
        let!(:process_time) { FactoryGirl.build(:process_time) }
        before :each do
          Processor::Preparer.expects(:perform).with(subject)
          Processor::Downloader.expects(:perform).with(subject)
          Processor::Collector.expects(:perform).with(subject)
          Processor::TreeBuilder.expects(:perform).with(subject)
          Processor::Aggregator.expects(:perform).with(subject)
          Processor::CompoundResultCalculator.expects(:perform).with(subject)
          Processor::Interpreter.expects(:perform).with(subject)
        end

        it 'should run' do
          subject.run
        end

      end

      context 'with a canceled processing' do
        before :each do
          processing.state = "CANCELED"
        end

        it 'is expected to destroy yhe processing' do
          processing.expects(:destroy)
          subject.run
        end
      end

      context 'with a failed step' do
        let!(:error_message) { 'Error message' }
        before :each do
          Processor::Preparer.expects(:perform).with(subject).raises(Errors::ProcessingError, error_message)
        end

        it 'is expected to update the processing state to ERROR' do
          processing.expects(:update).with(state: 'ERROR', error_message: error_message)

          subject.run
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
