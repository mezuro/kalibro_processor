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
          ProcessTime.expects(:create).with(state: "PREPARING", processing: processing).returns(process_time)
          ProcessTime.expects(:create).with(state: "DOWNLOADING", processing: processing).returns(process_time)
          ProcessTime.expects(:create).with(state: "COLLECTING", processing: processing).returns(process_time)
          ProcessTime.expects(:create).with(state: "BUILDING", processing: processing).returns(process_time)
          ProcessTime.expects(:create).with(state: "AGGREGATING", processing: processing).returns(process_time)
          ProcessTime.expects(:create).with(state: "CALCULATING", processing: processing).returns(process_time)
          ProcessTime.expects(:create).with(state: "INTERPRETING", processing: processing).returns(process_time)
          Processor::Preparer.expects(:prepare).with(subject)
          Processor::Downloader.expects(:download).with(subject)
          Processor::Collector.expects(:collect).with(subject)
          Processor::TreeBuilder.expects(:build_tree).with(processing)
          Processor::Aggregator.expects(:aggregate).with(processing.root_module_result, subject.native_metrics)
          Processor::CompoundResultCalculator.expects(:calculate_compound_results).with(processing.root_module_result, subject.compound_metrics)
          Processor::Interpreter.expects(:interpret).with(processing.root_module_result)
          process_time.expects(:update).times(7)
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
