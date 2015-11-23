require 'rails_helper'
require 'processor'

describe Processor::Interpreter do
  describe 'methods' do
    describe 'task' do
      context 'when the module result tree has been well-built' do
        let(:kalibro_configuration) { FactoryGirl.build(:kalibro_configuration) }
        let!(:code_dir) { "/tmp/test" }
        let!(:repository) { FactoryGirl.build(:repository, scm_type: "GIT", kalibro_configuration: kalibro_configuration, code_directory: code_dir) }
        let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
        let!(:metric_result) { FactoryGirl.build(:tree_metric_result,
                                                 metric_configuration: metric_configuration) }
        let!(:module_result) { FactoryGirl.build(:module_result_class_granularity,
                                                 tree_metric_results: [metric_result]) }
        let!(:processing) { FactoryGirl.build(:processing, repository: repository, root_module_result: module_result) }
        let!(:context) { FactoryGirl.build(:context, repository: repository, processing: processing) }

        before :each do
          module_result.expects(:children).returns([])
        end

        context 'when the module_result has a grade' do
          let!(:range) { FactoryGirl.build(:range) }
          let!(:reading) { FactoryGirl.build(:reading) }
          let!(:weight) { metric_configuration.weight }
          let!(:quotient) { (reading.grade * weight) / weight }

          before :each do
            module_result.tree_metric_results.first.expects(:has_grade?).returns(true)
            module_result.tree_metric_results.first.expects(:range).returns(range)
            module_result.expects(:update).with(grade: quotient)
            metric_result.expects(:metric_configuration).returns(metric_configuration)
            range.expects(:reading).returns(reading)
          end

          it 'is expected to interpret, updating grade to quotient' do
            Processor::Interpreter.task(context)
          end
        end

        context 'when the module_result does not have a grade' do
          before :each do
            metric_result.expects(:metric_configuration).returns(metric_configuration)
            module_result.tree_metric_results.first.expects(:has_grade?).returns(false)
            module_result.expects(:update).with(grade: 0)
          end

          it 'is expected to interpret, updating grade to 0' do
            Processor::Interpreter.task(context)
          end
        end
      end
    end

    describe 'state' do
      it 'is expected to return "INTERPRETING"' do
        expect(Processor::Interpreter.state).to eq("INTERPRETING")
      end
    end
  end
end
