require 'rails_helper'

# FIXME: Rewrite this after rspec gets support to ActiveJob
describe ProcessingJob, :type => :job do

  describe 'methods' do
    describe 'perform' do
      context 'when the processing is successful' do
        let!(:periodic_processing) { FactoryGirl.build(:periodic_processing, id: 1) }
        let!(:new_periodic_processing) { FactoryGirl.build(:periodic_processing, state: 'PREPARING') }
        let(:repository_with_period) { FactoryGirl.build(:repository, id: 2, period: 2) }
        let(:context) { FactoryGirl.build(:context, repository: repository_with_period, processing: periodic_processing) }
        let(:periodic_job) { mock('active_job') }

        # GLobalID tries to serialize the objects and then find them.
        # This may get fixed on a new version of RSpec compatible with Rails 4.2
        before :each do
          Repository.expects(:find).with(repository_with_period.id.to_s).returns(repository_with_period)
          Processing.expects(:find).with(periodic_processing.id.to_s).returns(periodic_processing)
        end

        context 'with periodicity' do
          before :each do
            Processor::Preparer.expects(:perform)
            Processor::Downloader.expects(:perform)
            Processor::Collector.expects(:perform)
            Processor::MetricResultsChecker.expects(:perform)
            Processor::TreeBuilder.expects(:perform)
            Processor::Aggregator.expects(:perform)
            Processor::CompoundResultCalculator.expects(:perform)
            Processor::Interpreter.expects(:perform)
          end

          it 'should process the repository periodically' do
            ScheduledProcessingJob.expects(:set).with(wait: 2.days).returns(periodic_job)
            periodic_job.expects(:perform_later).with(context.repository)
            ProcessingJob.perform_later(repository_with_period, periodic_processing)
          end
        end
      end

      context 'when the processing is interrupted' do
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

        context 'with a canceled processing' do
          before :each do
            processing.state = "CANCELED"
            ExceptionNotifier.stubs(:notify_exception).raises(RuntimeError) # Ensure no notification is getting out
          end

          it 'is expected to destroy the processing' do
            processing.expects(:destroy)
            ProcessingJob.perform_later(repository, processing)
          end
        end

        context 'with a failed step' do
          let!(:error_message) { 'Error message' }
          before :each do
            Processor::Preparer.expects(:perform).raises(Errors::ProcessingError, error_message)
          end

          it 'is expected to update the processing state to ERROR if a ProcessingError is raised' do
            processing.expects(:update).with(state: 'ERROR', error_message: error_message)

            ProcessingJob.perform_later(repository, processing)
          end
        end

        context 'with empty module_results' do
          before :each do
            Processor::Preparer.expects(:perform)
            Processor::Downloader.expects(:perform)
            Processor::Collector.expects(:perform).raises(Errors::EmptyModuleResultsError)
          end

          it 'is expected to update the processing state to READY' do
            processing.expects(:update).with(state: 'READY')

            ProcessingJob.perform_later(repository, processing)
          end
        end

        context 'with an unexpected error' do
          let(:exception) { Likeno::Errors::RecordNotFound.new }
          let(:no_method_error) { NoMethodError.new("NoMethodError") }

          it 'is expected to raise the error and notify' do
            Processor::Preparer.expects(:perform).raises(exception)
            ExceptionNotifier.expects(:notify_exception).with(exception)
            expect{ ProcessingJob.perform_later(repository, processing) }.to raise_error(exception)
          end

          it 'is expected to update the processing state to ERROR if a NoMethodError is raised' do
            Processor::Preparer.expects(:perform).raises(no_method_error)
            processing.expects(:update).with(state: 'ERROR', error_message: "NoMethodError")

            ExceptionNotifier.expects(:notify_exception).with(no_method_error)
            expect{ ProcessingJob.perform_later(repository, processing) }.to raise_error(no_method_error)
          end
        end
      end
    end
  end
end
