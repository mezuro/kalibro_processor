require 'rails_helper'
require 'metric_collector'
require 'processor'

describe Processor::Collector do
  describe 'methods' do
    describe 'task' do
      let(:configuration) { FactoryGirl.build(:configuration) }
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", configuration: configuration) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository) }
      let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
      let!(:runner) { Runner.new(repository, processing) }
      let!(:code_dir) { "/tmp/test" }

      before :each do
        runner.repository.expects(:code_directory).returns(code_dir)
        runner.expects(:native_metrics).returns({metric_configuration.metric_collector_name => [metric_configuration]})
        MetricCollector::Native::Analizo.any_instance.expects(:collect_metrics).with(code_dir, [metric_configuration], processing)
      end

      context 'without producing module_results' do
        it 'is expected to raise an EmptyModuleResultsError' do
          expect { Processor::Collector.task(runner) }.to raise_error(Errors::EmptyModuleResultsError)
        end
      end

      context 'producing module_results' do
        before :each do
          runner.processing.expects(:module_results).returns([mock("module_result")])
        end
        it 'is expected to accomplish the collecting state of a process successfully' do
          Processor::Collector.task(runner)
        end
      end
    end

    describe 'state' do
      it 'is expected to return "COLLECTING"' do
        expect(Processor::Collector.state).to eq("COLLECTING")
      end
    end
  end
end
