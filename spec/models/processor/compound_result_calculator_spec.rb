require 'rails_helper'

describe Processor::CompoundResultCalculator do
  describe 'methods' do
    describe 'calculate_compound_results' do
      let!(:root_module_result) { FactoryGirl.build(:module_result) }
      let!(:module_result) { FactoryGirl.build(:module_result_class_granularity, parent: root_module_result) }
      let!(:compound_metric_configurations) { [FactoryGirl.build(:compound_metric_configuration)] }

      context 'when the module result tree has been well-built' do

        before :each do
          root_module_result.expects(:children).twice.returns([module_result])
          CompoundResults::Calculator.any_instance.expects(:calculate).twice #One for each module_result
        end

        it 'is expected to calculate the compound results' do
          Processor::CompoundResultCalculator.calculate_compound_results(root_module_result, compound_metric_configurations)
        end
      end
    end
  end
end