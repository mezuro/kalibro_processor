require 'rails_helper'

describe Processor::Collector, :type => :model do
  describe 'methods' do
    describe 'collect' do
      let(:configuration) { FactoryGirl.build(:configuration) }
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", configuration: configuration) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository) }
      let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
      let(:native_metric) { [metric_configuration.base_tool_name] }
      let!(:runner) { Runner.new(repository, processing) }
      let!(:code_dir) { "/tmp/test" }

      before :each do
        runner.repository.expects(:code_directory).returns(code_dir)
        runner.expects(:native_metrics).returns({metric_configuration.base_tool_name => [metric_configuration]})
        AnalizoMetricCollector.any_instance.expects(:collect_metrics).with(code_dir, [metric_configuration], processing)
      end

      it 'is expected to accomplish the collecting state of a process successfully' do
        Processor::Collector.collect(runner)
      end
    end
  end
end
