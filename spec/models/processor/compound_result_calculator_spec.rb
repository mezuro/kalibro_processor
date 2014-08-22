require 'rails_helper'

describe Processor::CompoundResultCalculator do
  describe 'methods' do
    describe 'task' do
      let(:configuration) { FactoryGirl.build(:configuration) }
      let!(:code_dir) { "/tmp/test" }
      let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", configuration: configuration, code_directory: code_dir) }
      let!(:root_module_result) { FactoryGirl.build(:module_result) }
      let!(:processing) { FactoryGirl.build(:processing, repository: repository, root_module_result: root_module_result) }
      let!(:module_result) { FactoryGirl.build(:module_result_class_granularity, parent: root_module_result) }
      let!(:compound_metric_configurations) { [FactoryGirl.build(:compound_metric_configuration)] }
      let!(:runner) { Runner.new(repository, processing) }

      before :each do
        runner.compound_metrics = compound_metric_configurations
      end

      context 'when the module result tree has been well-built' do

        before :each do
          runner.processing.root_module_result.expects(:pre_order).returns([root_module_result, module_result])
        end

        context 'without calculation errors' do
          before :each do
            CompoundResults::Calculator.any_instance.expects(:calculate).twice #One for each module_result
          end

          it 'is expected to calculate the compound results' do
            Processor::CompoundResultCalculator.task(runner)
          end
        end

        context 'with calculation errors' do
          before :each do
            # To create a V8 error object, three params are needed. The first concerns the message error. However, we do not know the usage of the others.
            CompoundResults::Calculator.any_instance.expects(:calculate).raises(V8::Error.new("Error", nil, nil))
          end

          it 'is expected to raise a processing error' do
            expect {Processor::CompoundResultCalculator.task(runner)}.to raise_error(Errors::ProcessingError, "Javascript error with message: Error")
          end
        end
      end
    end

    describe 'state' do
      it 'is expected to return "CALCULATING"' do
        expect(Processor::CompoundResultCalculator.state).to eq("CALCULATING")
      end
    end
  end
end
