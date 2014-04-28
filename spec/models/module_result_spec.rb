require 'spec_helper'

describe ModuleResult do
  describe 'method' do
    describe 'initialize' do
      context 'with valid attributes' do
        let(:my_parent) { FactoryGirl.build(:module_result) }
        let(:kalibro_module) { FactoryGirl.build(:kalibro_module) }

        subject { FactoryGirl.build(:module_result, parent: my_parent) }

        it 'should return an instance of ModuleResult' do
          subject.should be_a(ModuleResult)
        end

        it 'should have the right attributes' do
          subject.parent.should eq(my_parent)
          subject.height.should eq(0)
          subject.children.should eq([])
        end
      end
    end

    describe 'children' do
      context 'when a module result has children' do
        let(:child_module_result) { FactoryGirl.build(:module_result) }
        let(:parent_module_result) { FactoryGirl.build(:module_result, children: [child_module_result]) }
        it 'should set the children parents' do
          parent_module_result.children.should eq([child_module_result])
          child_module_result.parent.should eq(parent_module_result)
        end
      end
    end

    describe 'metric_result_for' do
      subject { FactoryGirl.build(:module_result) }
      let(:metric_result) {subject.metric_results.first}
      context 'when a module result has the specific metric' do
        let(:metric) { subject.metric_results.first.metric }
        it 'should return the metric_result' do
          subject.metric_result_for(metric).should eq(metric_result)
        end
      end
      context 'when a module result has not the specific metric' do
        let(:another_metric) { FactoryGirl.build(:native_metric) }
        it 'should return the metric_result' do
          subject.metric_result_for(another_metric).should be_nil
        end
      end
    end
  end
end
