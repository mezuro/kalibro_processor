require 'rails_helper'

# FIXME: Rewrite this after rspec gets support to ActiveJob
describe ScheduledProcessingJob, :type => :job do
  describe 'methods' do
    describe 'perform' do
      let!(:repository_with_period) { FactoryGirl.build(:repository, id: 2, period: 2) }
      let(:new_periodic_processing) { FactoryGirl.build(:periodic_processing, state: 'PREPARING') }

      before :each do
        Repository.expects(:find).with(repository_with_period.id.to_s).returns(repository_with_period)
      end

      it 'is expected to create a processing and enqueue a new ProcessingJob' do
        Processing.expects(:create).with(repository: repository_with_period, state: "PREPARING").returns(new_periodic_processing)
        ProcessingJob.expects(:perform_later).with(repository_with_period, new_periodic_processing)

        ScheduledProcessingJob.perform_later(repository_with_period)
      end
    end
  end
end