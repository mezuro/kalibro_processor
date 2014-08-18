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
